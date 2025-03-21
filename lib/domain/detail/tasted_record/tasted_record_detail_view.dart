import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
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
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/detail/tasted_record/tasted_record_presenter.dart';
import 'package:brew_buds/domain/detail/widget/bean_detail.dart';
import 'package:brew_buds/domain/detail/widget/taste_graph.dart';
import 'package:brew_buds/domain/report/report_screen.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class TastedRecordDetailView extends StatefulWidget {
  const TastedRecordDetailView({super.key});

  @override
  State<TastedRecordDetailView> createState() => _TastedRecordDetailViewState();
}

class _TastedRecordDetailViewState extends State<TastedRecordDetailView>
    with SnackBarMixin<TastedRecordDetailView>, CenterDialogMixin<TastedRecordDetailView> {
  late final Throttle paginationThrottle;
  late final TextEditingController _textEditingController;
  late final ScrollController _scrollController;
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
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TastedRecordPresenter>().init();
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _fetchMoreData() {
    context.read<TastedRecordPresenter>().fetchMoreComments();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: _buildAppbar(),
          body: LayoutBuilder(builder: (context, constraints) {
            return NotificationListener<ScrollNotification>(
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
                    Selector<TastedRecordPresenter, List<String>>(
                      selector: (context, presenter) => presenter.imageUrlList,
                      builder: (context, imageUrlList, child) => _buildImageListView(imageUrlList: imageUrlList),
                    ),
                    Selector<TastedRecordPresenter, BottomButtonInfo>(
                      selector: (context, presenter) => presenter.bottomButtonInfo,
                      builder: (context, bottomButtonInfo, child) => _buildButtons(
                        likeCount: bottomButtonInfo.likeCount,
                        isLiked: bottomButtonInfo.isSaved,
                        isSaved: bottomButtonInfo.isSaved,
                      ),
                    ),
                    Selector<TastedRecordPresenter, String>(
                      selector: (context, presenter) => presenter.title,
                      builder: (context, title, child) => _buildTitle(title: title),
                    ),
                    Selector<TastedRecordPresenter, ProfileInfo>(
                      selector: (context, presenter) => presenter.profileInfo,
                      builder: (context, profileInfo, child) => _buildAuthorProfile(
                        nickName: profileInfo.nickName,
                        authorId: profileInfo.authorId,
                        profileImageUrl: profileInfo.profileImageUrl,
                        isFollow: profileInfo.isFollow,
                        isMine: profileInfo.isMine,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Selector<TastedRecordPresenter, ContentsInfo>(
                      selector: (context, presenter) => presenter.contentsInfo,
                      builder: (context, contentsInfo, child) => _buildContents(
                        rating: contentsInfo.rating,
                        flavors: contentsInfo.flavors,
                        tastedAt: contentsInfo.tastedAt,
                        contents: contentsInfo.contents,
                        location: contentsInfo.location,
                      ),
                    ),
                    const SizedBox(height: 48),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 24),
                      decoration: BoxDecoration(
                        color: ColorStyles.gray10,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Column(
                        children: [
                          Selector<TastedRecordPresenter, BeanInfo>(
                            selector: (context, presenter) => presenter.beanInfo,
                            builder: (context, beanInfo, child) => BeanDetail(
                              beanType: beanInfo.beanType.toString(),
                              country: beanInfo.country,
                              region: beanInfo.region,
                              variety: beanInfo.variety,
                              process: beanInfo.process,
                              roastery: beanInfo.roastery,
                              extraction: beanInfo.extraction,
                              roastPoint: beanInfo.roastingPoint,
                            ),
                          ),
                          Selector<TastedRecordPresenter, TasteReview?>(
                            selector: (context, presenter) => presenter.tastingReview,
                            builder: (context, tastingReview, child) => tastingReview != null
                                ? TasteGraph(
                                    bodyValue: tastingReview.body,
                                    acidityValue: tastingReview.acidity,
                                    bitternessValue: tastingReview.bitterness,
                                    sweetnessValue: tastingReview.sweetness,
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ].separator(separatorWidget: const SizedBox(height: 32)).toList(),
                      ),
                    ),
                    const SizedBox(height: 48),
                    Selector<TastedRecordPresenter, CommentsInfo>(
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
            );
          }),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Selector<TastedRecordPresenter, CommentTextFieldState>(
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
  }

  AppBar _buildAppbar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            const Text('시음기록', style: TextStyles.title02SemiBold),
            const Spacer(),
            Selector<TastedRecordPresenter, bool>(
              selector: (context, presenter) => presenter.isMine,
              builder: (context, isMine, child) => GestureDetector(
                onTap: () {
                  showActionBottomSheet(isMine: isMine).then((result) {
                    if (result != null) {
                      context.pop(result);
                    }
                  });
                },
                child: SvgPicture.asset(
                  'assets/icons/more.svg',
                  fit: BoxFit.cover,
                  height: 24,
                  width: 24,
                ),
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

  Widget _buildBottomTextField({String? prentCommentAuthorNickname, required String authorNickname}) {
    final bool hasParent = prentCommentAuthorNickname != null;
    return SafeArea(
      child: Container(
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
                      InkWell(
                        onTap: () {
                          context.read<TastedRecordPresenter>().cancelReply();
                        },
                        child: SvgPicture.asset(
                          'assets/icons/x_round.svg',
                          height: 24,
                          width: 24,
                        ),
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
                              .read<TastedRecordPresenter>()
                              .createComment(_textEditingController.text)
                              .then((_) => _textEditingController.value = TextEditingValue.empty);
                        }
                      },
                    ),
                  ),
                  suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 63),
                  constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageListView({required List<String> imageUrlList}) {
    final width = MediaQuery.of(context).size.width;
    return HorizontalSliderWidget(
      itemLength: imageUrlList.length,
      itemBuilder: (context, index) => MyNetworkImage(
        imageUrl: imageUrlList[index],
        height: width,
        width: width,
      ),
    );
  }

  Widget _buildButtons({
    required int likeCount,
    required bool isLiked,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
      child: Row(
        children: [
          LikeButton(
            onTap: () {
              context.read<TastedRecordPresenter>().onTappedLikeButton();
            },
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          const Spacer(),
          SaveButton(
            onTap: () {
              context.read<TastedRecordPresenter>().onTappedSaveButton();
            },
            isSaved: isSaved,
          ),
        ],
      ),
    );
  }

  Widget _buildTitle({required String title}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
          height: 26.25 / 22,
          letterSpacing: -0.02,
        ),
      ),
    );
  }

  Widget _buildAuthorProfile({
    required String nickName,
    int? authorId,
    required String profileImageUrl,
    required bool isFollow,
    required bool isMine,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          final id = authorId;
          if (id != null) {
            context.pop();
            pushToProfile(context: context, id: id);
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MyNetworkImage(
              imageUrl: profileImageUrl,
              height: 36,
              width: 36,
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                nickName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: TextStyles.title02SemiBold,
              ),
            ),
            if (!isMine) ...[
              FollowButton(
                onTap: () {
                  context.read<TastedRecordPresenter>().onTappedFollowButton();
                },
                isFollowed: isFollow,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildContents({
    required double rating,
    required List<String> flavors,
    required String tastedAt,
    required String contents,
    required String location,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              ...List.generate(
                5,
                (index) {
                  final i = index + 1;
                  if (i <= rating) {
                    return SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                    );
                  } else if (i - rating < 1) {
                    return SvgPicture.asset(
                      'assets/icons/star_half.svg',
                      height: 16,
                      width: 16,
                    );
                  } else {
                    return SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 16,
                      width: 16,
                      colorFilter: const ColorFilter.mode(ColorStyles.gray40, BlendMode.srcIn),
                    );
                  }
                },
              ),
              const SizedBox(width: 2),
              Text(
                '$rating',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    height: 18 / 12,
                    letterSpacing: -0.01,
                    color: ColorStyles.gray70),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Row(
            children: flavors
                .map((flavor) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 0.8),
                          borderRadius: const BorderRadius.all(Radius.circular(6))),
                      child: Text(flavor, style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray70)),
                    ))
                .separator(separatorWidget: const SizedBox(width: 2))
                .toList()
              ..addAll(
                [
                  const Spacer(),
                  Text(tastedAt, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50)),
                ],
              ),
          ),
          const SizedBox(height: 12),
          Text(contents, style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: ColorStyles.gray10,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  'assets/icons/location.svg',
                  height: 16,
                  width: 16,
                ),
                const SizedBox(width: 4),
                const Text('장소', style: TextStyles.labelSmallSemiBold),
                const SizedBox(width: 8),
                Text(location, style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.black)),
                const Spacer(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCommentTitle({required int commentsCount}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16),
      child: Text(
        '댓글 ($commentsCount)',
        style: TextStyles.title01SemiBold,
      ),
    );
  }

  Widget buildEmptyComments() {
    return const SizedBox(
      height: 270,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('아직 댓글이 없어요', style: TextStyles.title02SemiBold),
          SizedBox(height: 8),
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
                        context.pop();
                        pushToProfile(context: context, id: comment.author.id);
                      },
                      onTappedReply: () {
                        context.read<TastedRecordPresenter>().onTappedReply(comment);
                      },
                      onTappedLikeButton: () {
                        context.read<TastedRecordPresenter>().onTappedCommentLikeButton(comment);
                      },
                    ),
                    isMine: context.read<TastedRecordPresenter>().isMineComment(comment),
                    canDelete: context.read<TastedRecordPresenter>().canDeleteComment(authorId: comment.author.id),
                    onDelete: () {
                      context.read<TastedRecordPresenter>().onTappedDeleteCommentButton(comment);
                    },
                  ),
                  if (comment.reComments.isNotEmpty) ...[
                    ReCommentsList(
                      reCommentsLength: comment.reComments.length,
                      reCommentsBuilder: (index) {
                        final reComment = comment.reComments[index];
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
                              context.read<TastedRecordPresenter>().onTappedCommentLikeButton(
                                    reComment,
                                    parentComment: comment,
                                  );
                            },
                          ),
                          isMine: context.read<TastedRecordPresenter>().isMineComment(reComment),
                          canDelete:
                              context.read<TastedRecordPresenter>().canDeleteComment(authorId: comment.author.id),
                          onDelete: () {
                            context.read<TastedRecordPresenter>().onTappedDeleteCommentButton(reComment);
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
  }) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: !isMine && canDelete ? 0.4 : 0.2,
        motion: const DrawerMotion(),
        children: [
          if (canDelete)
            Expanded(
              child: GestureDetector(
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
              child: GestureDetector(
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

  Future<String?> showActionBottomSheet({required bool isMine}) {
    return showBarrierDialog<String>(
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
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: isMine ? _buildMineBottomSheet() : _buildOthersBottomSheet(),
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
        GestureDetector(
          onTap: () {},
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
        GestureDetector(
          onTap: () {
            context.pop();
            showCenterDialog<Result<String>>(
              title: '정말 삭제하시겠어요?',
              centerTitle: true,
              cancelText: '닫기',
              doneText: '삭제하기',
              onDone: () {
                context.read<TastedRecordPresenter>().onDelete().then((result) {
                  context.pop(result);
                });
              },
            ).then((result) {
              switch (result) {
                case null:
                  break;
                case Success<String>():
                  context.pop(result.data);
                  break;
                case Error<String>():
                  showSnackBar(message: result.e);
                  break;
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '샥제하기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: GestureDetector(
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

  Widget _buildOthersBottomSheet() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            final id = context.read<TastedRecordPresenter>().id;
            context.pop();
            pushToReportScreen(context, id: id, type: 'tasted_record').then((result) {
              if (result != null) {
                context.pop(result);
              }
            });
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
        GestureDetector(
          onTap: () {
            context.pop();
            showCenterDialog<Result<String>>(
              title: '이 사용자를 차단하시겠어요?',
              content: '차단된 계정은 회원님의 프로필과 콘텐츠를 볼 수 없으며, 차단 사실은 상대방에게 알려지지 않습니다. 언제든 설정에서 차단을 해제할 수 있습니다.',
              cancelText: '취소',
              doneText: '차단하기',
              onDone: () {
                context.read<TastedRecordPresenter>().onBlock().then((result) {
                  context.pop(result);
                });
              },
            ).then((result) {
              switch (result) {
                case null:
                  break;
                case Success<String>():
                  context.pop(result.data);
                  break;
                case Error<String>():
                  showSnackBar(message: result.e);
                  break;
              }
            });
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
          child: GestureDetector(
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
}
