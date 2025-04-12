import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/like_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/common/widgets/save_button.dart';
import 'package:brew_buds/common/widgets/send_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/detail/post/post_detail_presenter.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_button.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:brew_buds/domain/report/report_screen.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

enum PostDetailAction {
  update,
  delete,
  block,
  report;
}

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView>
    with SnackBarMixin<PostDetailView>, CenterDialogMixin<PostDetailView> {
  late final Throttle paginationThrottle;
  late final TextEditingController _textEditingController;
  int currentIndex = 0;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(seconds: 3),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchMoreData();
      },
    );
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PostDetailPresenter>().init();
    });
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<PostDetailPresenter>().fetchMorComments();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PostDetailPresenter, bool>(
        selector: (context, presenter) => presenter.isEmpty,
        builder: (context, isEmpty, child) {
          if (isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showEmptyDialog().then((value) => context.pop());
            });
          }
          return ThrottleButton(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: SafeArea(
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                appBar: _buildTitle(),
                body: NotificationListener<ScrollNotification>(
                  onNotification: (ScrollNotification scroll) {
                    if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent * 0.7) {
                      paginationThrottle.setValue(null);
                    }
                    return false;
                  },
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Selector<PostDetailPresenter, ProfileInfo>(
                          selector: (context, presenter) => presenter.profileInfo,
                          builder: (context, profileInfo, child) => _buildProfile(
                            authorId: profileInfo.authorId,
                            nickName: profileInfo.nickName,
                            imageUrl: profileInfo.profileImageUrl,
                            createdAt: profileInfo.createdAt,
                            viewCount: profileInfo.viewCount,
                            isFollow: profileInfo.isFollow,
                            isMine: profileInfo.isMine,
                          ),
                        ),
                        Selector<PostDetailPresenter, BodyInfo>(
                          selector: (context, presenter) => presenter.bodyInfo,
                          builder: (context, bodyInfo, child) => buildBody(
                            imageUrlList: bodyInfo.imageUrlList,
                            tastingRecords: bodyInfo.tastingRecords,
                            title: bodyInfo.title,
                            contents: bodyInfo.contents,
                            tag: bodyInfo.tag,
                            subject: bodyInfo.subject,
                          ),
                        ),
                        Selector<PostDetailPresenter, BottomButtonInfo>(
                          selector: (context, presenter) => presenter.bottomButtonInfo,
                          builder: (context, bottomButtonInfo, child) => buildBottomButtons(
                            likeCount: bottomButtonInfo.likeCount,
                            isLiked: bottomButtonInfo.isLiked,
                            isSaved: bottomButtonInfo.isSaved,
                          ),
                        ),
                        Container(height: 12, color: ColorStyles.gray20),
                        Selector<PostDetailPresenter, CommentsInfo>(
                          selector: (context, presenter) => presenter.commentsInfo,
                          builder: (context, commentsInfo, child) => buildComments(
                            authorId: commentsInfo.authorId,
                            comments: commentsInfo.page.results,
                            count: commentsInfo.page.count,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: SafeArea(
                  child: Padding(
                    padding: MediaQuery.of(context).viewInsets,
                    child: Selector<PostDetailPresenter, CommentTextFieldState>(
                      selector: (context, presenter) => presenter.commentTextFieldState,
                      builder: (context, state, child) {
                        return _buildBottomTextField(
                          prentCommentAuthorNickname: state.prentCommentAuthorNickname,
                          authorNickname: state.authorNickname,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  AppBar _buildTitle() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset('assets/icons/x.svg', fit: BoxFit.cover, height: 24, width: 24),
            ),
            const Spacer(),
            Text('게시물', style: TextStyles.title02SemiBold),
            const Spacer(),
            Selector<PostDetailPresenter, bool>(
              selector: (context, presenter) => presenter.isMine,
              builder: (context, isMine, child) => ThrottleButton(
                onTap: () {
                  showActionBottomSheet(isMine: isMine).then((result) {
                    switch (result) {
                      case null:
                        break;
                      case PostDetailAction.update:
                        final post = context.read<PostDetailPresenter>().post;
                        if (post != null) {
                          showPostUpdateScreen(context: context, post: post).then((value) {
                            if (value != null && value && context.mounted) {
                              context.read<PostDetailPresenter>().onRefresh();
                              showSnackBar(message: '게시글 수정을 완료했어요.');
                            }
                          });
                        }
                        break;
                      case PostDetailAction.delete:
                        showCenterDialog(
                          title: '정말 삭제하시겠어요?',
                          centerTitle: true,
                          cancelText: '닫기',
                          doneText: '삭제하기',
                        ).then((result) {
                          if (result != null && result) {
                            context.read<PostDetailPresenter>().onDelete().then((value) {
                              switch (value) {
                                case Success<String>():
                                  context.pop(value.data);
                                  break;
                                case Error<String>():
                                  showSnackBar(message: value.e);
                                  break;
                              }
                            });
                          }
                        });
                        break;
                      case PostDetailAction.block:
                        showCenterDialog(
                          title: '이 사용자를 차단하시겠어요?',
                          content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
                          cancelText: '취소',
                          doneText: '차단하기',
                        ).then((result) {
                          if (result != null && result) {
                            context.read<PostDetailPresenter>().onBlock().then((value) {
                              switch (value) {
                                case Success<String>():
                                  context.pop(value.data);
                                  break;
                                case Error<String>():
                                  showSnackBar(message: value.e);
                                  break;
                              }
                            });
                          }
                        });
                        break;
                      case PostDetailAction.report:
                        final id = context.read<PostDetailPresenter>().id;
                        pushToReportScreen(context, id: id, type: 'post').then((result) {
                          if (result != null) {
                            context.pop(result);
                          }
                        });
                        break;
                    }
                  });
                },
                child: SvgPicture.asset('assets/icons/more.svg', fit: BoxFit.cover, height: 24, width: 24),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Container(
          width: double.infinity,
          height: 1,
          color: ColorStyles.gray20,
        ),
      ),
    );
  }

  Widget _buildProfile({
    required int? authorId,
    required String nickName,
    required String imageUrl,
    required String createdAt,
    required String viewCount,
    required bool isFollow,
    required bool isMine,
  }) {
    return ThrottleButton(
      onTap: () {
        if (authorId != null) {
          pushToProfile(context: context, id: authorId);
        }
      },
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyNetworkImage(imageUrl: imageUrl, height: 36, width: 36, shape: BoxShape.circle),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Text(nickName, textAlign: TextAlign.start, style: TextStyles.title01SemiBold),
                  ),
                  Expanded(
                    child: Text(
                      '$createdAt ・ 조회 $viewCount',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              ),
            ),
            if (!isMine) ...[
              const SizedBox(width: 8),
              FollowButton(
                onTap: () {
                  context.read<PostDetailPresenter>().onTappedFollowButton();
                },
                isFollowed: isFollow,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildBody({
    required List<String> imageUrlList,
    required List<TastedRecordInPost> tastingRecords,
    required String title,
    required String contents,
    required String tag,
    required PostSubject subject,
  }) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        if (imageUrlList.isNotEmpty)
          HorizontalSliderWidget(
            itemLength: imageUrlList.length,
            itemBuilder: (context, index) => MyNetworkImage(
              imageUrl: imageUrlList[index],
              height: width,
              width: width,
            ),
          ),
        if (tastingRecords.isNotEmpty)
          HorizontalSliderWidget(
            itemLength: tastingRecords.length,
            itemBuilder: (context, index) => TastingRecordCard(
              image: MyNetworkImage(
                imageUrl: tastingRecords[index].thumbnailUrl,
                height: width,
                width: width,
              ),
              rating: '${tastingRecords[index].rating}',
              type: tastingRecords[index].beanType,
              name: tastingRecords[index].beanName,
              tags: tastingRecords[index].flavors,
            ),
            childBuilder: (context, index) => ThrottleButton(
              onTap: () {
                context.pop();
                showTastingRecordDetail(context: context, id: tastingRecords[index].id);
              },
              child: Container(
                color: ColorStyles.white,
                child: TastingRecordButton(
                  name: tastingRecords[index].beanName,
                  bodyText: tastingRecords[index].contents,
                ),
              ),
            ),
          ),
        _buildTextBody(title: title, contents: contents, tag: tag, subject: subject),
      ],
    );
  }

  Widget _buildTextBody({
    required String title,
    required String contents,
    required String tag,
    required PostSubject subject,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [_buildSubject(subject: subject), const Spacer()]),
          const SizedBox(height: 12, width: double.infinity),
          Text(title, style: TextStyles.title01SemiBold),
          const SizedBox(height: 12, width: double.infinity),
          Text(contents, style: TextStyles.bodyRegular),
          if (tag.isNotEmpty) ...[
            const SizedBox(height: 12, width: double.infinity),
            Text(
              tag.replaceAll(',', '#').startsWith('#') ? tag.replaceAll(',', '#') : '#${tag.replaceAll(',', '#')}',
              style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSubject({required PostSubject subject}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SvgPicture.asset(
            subject.iconPath,
            colorFilter: const ColorFilter.mode(
              ColorStyles.white,
              BlendMode.srcIn,
            ),
            height: 12,
            width: 12,
          ),
          const SizedBox(width: 2),
          Text(subject.toString(), style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white)),
        ],
      ),
    );
  }

  Widget buildBottomButtons({
    required int likeCount,
    required bool isLiked,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
      child: Row(
        children: [
          LikeButton(
            onTap: () {
              context.read<PostDetailPresenter>().onTappedLikeButton();
            },
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          const Spacer(),
          SaveButton(
            onTap: () {
              context.read<PostDetailPresenter>().onTappedSaveButton();
            },
            isSaved: isSaved,
          ),
        ],
      ),
    );
  }

  //Api 수정
  Widget _buildCommentTitle({required int commentsCount}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text('댓글 ($commentsCount)', style: TextStyles.title01SemiBold),
    );
  }

  Widget buildEmptyComments() {
    return SizedBox(
      height: 270,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('아직 댓글이 없어요', style: TextStyles.title02SemiBold),
          const SizedBox(height: 8),
          Text('댓글을 남겨보세요.', style: TextStyles.captionSmallMedium),
        ],
      ),
    );
  }

  Widget buildComments({required int? authorId, required List<Comment> comments, required int count}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCommentTitle(commentsCount: count),
        if (comments.isEmpty)
          buildEmptyComments()
        else
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              final canDelete = context.read<PostDetailPresenter>().canDeleteComment(authorId: comment.author.id);
              return Column(
                children: [
                  _buildSlidableComment(
                    CommentItem(
                      padding: comment.reComments.isEmpty
                          ? const EdgeInsets.all(16)
                          : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                      profileImageUrl: comment.author.profileImageUrl,
                      nickName: comment.author.nickname,
                      createdAt: comment.createdAt,
                      isWriter: authorId == comment.author.id,
                      contents: comment.content,
                      isLiked: comment.isLiked,
                      likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                      canReply: true,
                      onTappedProfile: () {
                        pushToProfile(context: context, id: comment.author.id);
                      },
                      onTappedReply: () {
                        context.read<PostDetailPresenter>().onTappedReply(comment);
                      },
                      onTappedLikeButton: () {
                        context.read<PostDetailPresenter>().onTappedCommentLikeButton(comment);
                      },
                    ),
                    isMine: context.read<PostDetailPresenter>().isMineComment(comment),
                    canDelete: canDelete,
                    onDelete: () {
                      context.read<PostDetailPresenter>().onTappedDeleteCommentButton(comment);
                    },
                    onReport: () {
                      pushToReportScreen(context, id: comment.id, type: 'comment').then(
                        (value) {
                          if (value != null) {
                            showSnackBar(message: value);
                          }
                        },
                      );
                    },
                  ),
                  if (comment.reComments.isNotEmpty) ...[
                    ReCommentsList(
                      reCommentsLength: comment.reComments.length,
                      reCommentsBuilder: (index) {
                        final reComment = comment.reComments[index];
                        final canDelete =
                            context.read<PostDetailPresenter>().canDeleteComment(authorId: reComment.author.id);
                        return _buildSlidableComment(
                          CommentItem(
                            padding: const EdgeInsets.only(left: 60, right: 16, top: 12, bottom: 12),
                            profileImageUrl: reComment.author.profileImageUrl,
                            nickName: reComment.author.nickname,
                            createdAt: reComment.createdAt,
                            isWriter: authorId == comment.author.id,
                            contents: reComment.content,
                            isLiked: reComment.isLiked,
                            likeCount: '${reComment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                            onTappedProfile: () {
                              context.pop();
                              pushToProfile(context: context, id: reComment.author.id);
                            },
                            onTappedLikeButton: () {
                              context
                                  .read<PostDetailPresenter>()
                                  .onTappedCommentLikeButton(reComment, parentComment: comment);
                            },
                          ),
                          isMine: context.read<PostDetailPresenter>().isMineComment(reComment),
                          canDelete: canDelete,
                          onDelete: () {
                            context.read<PostDetailPresenter>().onTappedDeleteCommentButton(reComment);
                          },
                          onReport: () {
                            pushToReportScreen(context, id: reComment.id, type: 'comment').then(
                              (value) {
                                if (value != null) {
                                  showSnackBar(message: value);
                                }
                              },
                            );
                          },
                        );
                      },
                    )
                  ]
                ],
              );
            },
          ),
      ],
    );
  }

  Widget _buildSlidableComment(
    CommentItem commentItem, {
    required bool canDelete,
    Function()? onDelete,
    required bool isMine,
    Function()? onReport,
  }) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: !isMine && canDelete ? 0.4 : 0.2,
        motion: const DrawerMotion(),
        children: [
          if (canDelete)
            Expanded(
              child: ThrottleButton(
                onTap: () {
                  onDelete?.call();
                },
                child: Container(
                  color: ColorStyles.red,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/delete.svg',
                        height: 32,
                        width: 32,
                        colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                      ),
                      Text(
                        '삭제하기',
                        style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
          if (!isMine)
            Expanded(
              child: ThrottleButton(
                onTap: () {
                  onReport?.call();
                },
                child: Container(
                  color: ColorStyles.gray30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/declaration.svg',
                        height: 32,
                        width: 32,
                        colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
                      ),
                      Text(
                        '신고하기',
                        style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray70),
                      )
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      child: commentItem,
    );
  }

  Widget _buildBottomTextField({String? prentCommentAuthorNickname, required String authorNickname}) {
    final bool hasParent = prentCommentAuthorNickname != null;
    return Container(
      padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: ColorStyles.gray20)),
        color: ColorStyles.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: ColorStyles.gray40),
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          color: ColorStyles.white,
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: hasParent,
              child: Container(
                padding: const EdgeInsets.only(left: 14, top: 16, bottom: 16, right: 14),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  color: ColorStyles.gray10,
                ),
                child: Row(
                  children: [
                    Text(
                      '$prentCommentAuthorNickname님에게 답글 남기는 중',
                      style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
                    ),
                    const Spacer(),
                    ThrottleButton(
                      onTap: () {
                        context.read<PostDetailPresenter>().cancelReply();
                      },
                      child: SvgPicture.asset('assets/icons/x_round.svg', height: 24, width: 24),
                    )
                  ],
                ),
              ),
            ),
            TextField(
              controller: _textEditingController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: hasParent ? '답글 달기...' : '$authorNickname님에게 댓글 추가...',
                hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                  gapPadding: 8,
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                  gapPadding: 8,
                ),
                contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
                  child: SendButton(
                    onTap: () {
                      if (_textEditingController.text.isNotEmpty) {
                        context
                            .read<PostDetailPresenter>()
                            .createComment(_textEditingController.text)
                            .then((_) => _textEditingController.value = TextEditingValue.empty);
                      }
                    },
                  ),
                ),
                suffixIconConstraints: BoxConstraints(maxHeight: max(48, 48.h), maxWidth: 63.w),
                constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<PostDetailAction?> showActionBottomSheet({required bool isMine}) {
    return showBarrierDialog<PostDetailAction>(
      context: context,
      pageBuilder: (context, _, __) {
        return Stack(
          children: [
            Positioned(
              right: 0,
              left: 0,
              bottom: 0,
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: isMine ? _buildMineBottomSheet() : _buildOthersBottomSheet(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMineBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThrottleButton(
          onTap: () {
            context.pop(PostDetailAction.update);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '수정하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ThrottleButton(
          onTap: () {
            context.pop(PostDetailAction.delete);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '삭제하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ThrottleButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorStyles.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '닫기',
                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOthersBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ThrottleButton(
          onTap: () {
            context.pop(PostDetailAction.report);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '신고하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        ThrottleButton(
          onTap: () {
            context.pop(PostDetailAction.block);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '차단하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ThrottleButton(
            onTap: () {
              context.pop();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: const BoxDecoration(
                color: ColorStyles.black,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Text(
                '닫기',
                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> showEmptyDialog() {
    return showBarrierDialog(
      context: context,
      barrierColor: ColorStyles.black90,
      pageBuilder: (context, _, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '게시글을 불러오는데 실패했습니다.',
                          style: TextStyles.title02SemiBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.gray30,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '닫기',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.black,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '확인',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
