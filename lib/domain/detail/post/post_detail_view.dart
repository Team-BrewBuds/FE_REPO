import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/like_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/profile_image.dart';
import 'package:brew_buds/common/widgets/save_button.dart';
import 'package:brew_buds/common/widgets/send_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/comments/comments_presenter.dart';
import 'package:brew_buds/model/common/object_type.dart';
import 'package:brew_buds/domain/comments/widget/comment_presenter.dart';
import 'package:brew_buds/domain/comments/widget/comment_widget.dart';
import 'package:brew_buds/domain/detail/post/post_detail_presenter.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_button.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_card.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/cupertino.dart';
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

  static Widget buildWithPresenter({required int id}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostDetailPresenter(id: id)),
        ChangeNotifierProvider(
          create: (_) => CommentsPresenter(objectType: ObjectType.post, objectId: id),
        ),
      ],
      child: const PostDetailView(),
    );
  }

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> with CenterDialogMixin<PostDetailView> {
  late final Throttle paginationThrottle;
  late final FocusNode _focusNode;
  late final TextEditingController _textEditingController;
  int currentIndex = 0;

  @override
  void initState() {
    paginationThrottle = Throttle(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        context.read<CommentsPresenter>().fetchMoreData();
      },
    );
    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    paginationThrottle.cancel();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PostDetailPresenter, bool>(
        selector: (context, presenter) => presenter.isEmpty,
        builder: (context, isEmpty, child) {
          if (isEmpty) {
            //수정필요
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showEmptyDialog().then((value) => context.pop());
            });
          }
          return ThrottleButton(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: true,
              appBar: _buildTitle(),
              body: NotificationListener<ScrollNotification>(
                onNotification: (ScrollNotification scroll) {
                  if (scroll.metrics.pixels > scroll.metrics.maxScrollExtent - 300) {
                    paginationThrottle.setValue(null);
                  }
                  return false;
                },
                child: CustomScrollView(
                  slivers: [
                    Selector<PostDetailPresenter, ProfileInfo>(
                      selector: (context, presenter) => presenter.profileInfo,
                      builder: (context, profileInfo, child) => _buildProfile(
                        authorId: profileInfo.authorId,
                        nickName: profileInfo.nickName,
                        imageUrl: profileInfo.profileImageUrl,
                        createdAt: profileInfo.createdAt,
                        viewCount: profileInfo.viewCount,
                        isFollow: profileInfo.isFollow,
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
                    SliverToBoxAdapter(child: Container(height: 12, color: ColorStyles.gray20)),
                    Selector<CommentsPresenter, int>(
                      selector: (context, presenter) => presenter.totalCount,
                      builder: (context, totalCount, child) => _buildCommentTitle(commentsCount: totalCount),
                    ),
                    Selector<CommentsPresenter, List<CommentPresenter>>(
                      selector: (context, presenter) => presenter.commentPresenters,
                      builder: (context, commentPresenters, child) {
                        final isMyObject = context.read<PostDetailPresenter>().isMyObject();
                        final authorId = context.read<PostDetailPresenter>().authorId ?? 0;
                        return commentPresenters.isNotEmpty
                            ? SlidableAutoCloseBehavior(
                                child: SliverList.builder(
                                  itemCount: commentPresenters.length,
                                  itemBuilder: (context, index) {
                                    final presenter = commentPresenters[index];
                                    final isMyComment = context.read<PostDetailPresenter>().isMine(presenter.author.id);
                                    return ChangeNotifierProvider.value(
                                      value: presenter,
                                      child: CommentWidget(
                                        objectAuthorId: authorId,
                                        isMyObject: isMyObject,
                                        isMyComment: isMyComment,
                                        onTapReply: () {
                                          _focusNode.requestFocus();
                                          context.read<PostDetailPresenter>().selectedReply(
                                                presenter.author,
                                                presenter.id,
                                              );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              )
                            : SliverToBoxAdapter(child: buildEmptyComments());
                      },
                    ),
                    Selector<CommentsPresenter, bool>(
                      selector: (context, presenter) => presenter.hasNext && !presenter.isLoading,
                      builder: (context, hasNext, child) => hasNext
                          ? const SliverToBoxAdapter(
                              child: SizedBox(
                                height: 100,
                                child: Center(
                                  child: CupertinoActivityIndicator(
                                    color: ColorStyles.gray70,
                                  ),
                                ),
                              ),
                            )
                          : const SliverToBoxAdapter(),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: SafeArea(
                top: false,
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
              child: SvgPicture.asset('assets/icons/back.svg', fit: BoxFit.cover, height: 24, width: 24),
            ),
            const Spacer(),
            Text('게시글', style: TextStyles.title02SemiBold),
            const Spacer(),
            FutureButton(
              onTap: () => showActionBottomSheet(),
              onComplete: (result) {
                switch (result) {
                  case PostDetailAction.update:
                    final post = context.read<PostDetailPresenter>().post;
                    if (post != null) {
                      ScreenNavigator.showPostUpdateScreen(context: context, post: post.copyWith());
                    }
                    break;
                  case PostDetailAction.delete:
                    showCenterDialog(
                        title: '정말 삭제하시겠어요?',
                        centerTitle: true,
                        cancelText: '닫기',
                        doneText: '삭제하기',
                        onDone: () async {
                          try {
                            final context = this.context;
                            await context.read<PostDetailPresenter>().onDelete();
                            if (context.mounted) {
                              EventBus.instance.fire(const MessageEvent(message: '해당 게시글을 삭제했어요.'));
                              context.pop();
                            }
                          } catch (e) {
                            EventBus.instance.fire(const MessageEvent(message: '게시글 삭제에 실패했어요.'));
                          }
                        });
                    break;
                  case PostDetailAction.block:
                    showCenterDialog(
                      title: '이 사용자를 차단하시겠어요?',
                      content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
                      cancelText: '취소',
                      doneText: '차단하기',
                      onDone: () async {
                        final context = this.context;
                        final nickname = context.read<PostDetailPresenter>().authorNickname;
                        if (nickname != null) {
                          try {
                            await context.read<PostDetailPresenter>().onBlock();
                            EventBus.instance.fire(MessageEvent(message: '$nickname님을 차단했어요.'));
                          } catch (e) {
                            EventBus.instance.fire(MessageEvent(message: '$nickname님 차단에 실패했어요.'));
                          }
                        }
                      },
                    );
                    break;
                  case PostDetailAction.report:
                    final id = context.read<PostDetailPresenter>().id;
                    ScreenNavigator.pushToReportScreen(context, id: id, type: 'post');
                  default:
                    return;
                }
              },
              child: SvgPicture.asset('assets/icons/more.svg', fit: BoxFit.cover, height: 24, width: 24),
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
  }) {
    return SliverToBoxAdapter(
      child: ThrottleButton(
        onTap: () {
          if (authorId != null) {
            ScreenNavigator.showProfile(context: context, id: authorId);
          }
        },
        child: Container(
          height: 36,
          margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ProfileImage(imageUrl: imageUrl, height: 36, width: 36),
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
              if (!context.read<PostDetailPresenter>().isMyObject()) ...[
                const SizedBox(width: 8),
                FollowButton(
                  onTap: () => context.read<PostDetailPresenter>().onTappedFollowButton(),
                  isFollowed: isFollow,
                ),
              ],
            ],
          ),
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
    return SliverToBoxAdapter(
      child: Column(
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
                  showGradient: true,
                ),
                rating: '${tastingRecords[index].rating}',
                type: tastingRecords[index].beanType,
                name: tastingRecords[index].beanName,
                flavors: tastingRecords[index].flavors,
              ),
              childBuilder: (context, index) => ThrottleButton(
                onTap: () {
                  ScreenNavigator.showTastedRecordDetail(context: context, id: tastingRecords[index].id);
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
      ),
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
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
        child: Row(
          children: [
            LikeButton(
              onTap: () => context.read<PostDetailPresenter>().onTappedLikeButton(),
              isLiked: isLiked,
              likeCount: likeCount,
            ),
            const Spacer(),
            SaveButton(
              onTap: () => context.read<PostDetailPresenter>().onTappedSaveButton(),
              isSaved: isSaved,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommentTitle({required int commentsCount}) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 20),
        child: Text('댓글 ($commentsCount)', style: TextStyles.title01SemiBold),
      ),
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
              focusNode: _focusNode,
              controller: _textEditingController,
              maxLines: null,
              keyboardType: TextInputType.multiline,
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
                      return context.read<PostDetailPresenter>().createNewComment(content: _textEditingController.text);
                    },
                    onComplete: () {
                      _textEditingController.value = TextEditingValue.empty;
                    },
                    onError: (message) {
                      EventBus.instance.fire(MessageEvent(message: message));
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

  Future<PostDetailAction?> showActionBottomSheet() {
    final isMine = context.read<PostDetailPresenter>().isMyObject();
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
