import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/horizontal_slider_widget.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/di/navigator.dart';
import 'package:brew_buds/domain/detail/post_detail_presenter.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_feed/tasting_record_button.dart';
import 'package:brew_buds/domain/home/widgets/tasting_record_feed/tasting_record_card.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  late final TextEditingController _textEditingController;
  int currentIndex = 0;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<PostDetailPresenter>().init();
    });
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
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
          appBar: _buildTitle(),
          body: SingleChildScrollView(
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
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: _buildBottomTextField(),
          ),
        ),
      ),
    );
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
            const Text('게시물', style: TextStyles.title02SemiBold),
            const Spacer(),
            Selector<PostDetailPresenter, bool>(
              selector: (context, presenter) => presenter.isMine,
              builder: (context, isMine, child) => GestureDetector(
                onTap: () {
                  showSortCriteriaBottomSheet(isMine: isMine);
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

  Widget _buildProfile({
    required int? authorId,
    required String nickName,
    required String imageUrl,
    required String createdAt,
    required String viewCount,
  }) {
    return GestureDetector(
      onTap: () {
        if (authorId != null) {
          context.pop();
          pushToProfile(context: context, id: authorId);
        }
      },
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //프로필 사진
            MyNetworkImage(
              imageUrl: imageUrl,
              height: 36,
              width: 36,
              color: const Color(0xffD9D9D9),
              shape: BoxShape.circle,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    //닉네임
                    child: Text(
                      nickName,
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
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
            const SizedBox(width: 8),
            //Api 수정.
            FollowButton(onTap: () {}, isFollowed: false),
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
              color: const Color(0xffD9D9D9),
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
                color: const Color(0xffD9D9D9),
              ),
              rating: '${tastingRecords[index].rating}',
              type: tastingRecords[index].beanType,
              name: tastingRecords[index].beanName,
              tags: tastingRecords[index].flavors,
            ),
            childBuilder: (context, index) => GestureDetector(
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
        _buildTextBody(
          title: title,
          contents: contents,
          tag: tag,
          subject: subject,
        ),
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
          const SizedBox(height: 12, width: double.infinity),
          Text(
            tag.replaceAll(',', '#').startsWith('#') ? tag.replaceAll(',', '#') : '#${tag.replaceAll(',', '#')}',
            style: TextStyles.labelSmallMedium.copyWith(
              color: ColorStyles.red,
            ),
          ),
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
    required isLiked,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
      child: Row(
        children: [
          buildLikeButton(likeCount: likeCount, isLiked: isLiked),
          const Spacer(),
          buildSaveButton(isSaved: isSaved),
        ],
      ),
    );
  }

  //Api 변경 내가 좋아요 했는지 모름.
  Widget buildLikeButton({required int likeCount, required bool isLiked}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        isLiked ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isLiked ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '좋아요 $likeCount',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {
        context.read<PostDetailPresenter>().onTappedLikeButton();
      },
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildCommentButton({required int commentCount}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        'assets/icons/message.svg',
        height: 24,
        width: 24,
        colorFilter: const ColorFilter.mode(
          ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '댓글 $commentCount',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {},
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildSaveButton({required bool isSaved}) {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          isSaved ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      iconAlign: ButtonIconAlign.left,
      onTapped: () {},
    );
  }

  //Api 수정
  Widget _buildCommentTitle({required int commentsCount}) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
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

  Widget buildComments({required int? authorId, required List<Comment> comments}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildCommentTitle(commentsCount: comments.length),
        if (comments.isEmpty) ...[buildEmptyComments()] else
          ...comments.map((comment) {
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
                      context.pop();
                      pushToProfile(context: context, id: comment.author.id);
                    },
                    onTappedReply: () {},
                    onTappedLikeButton: () {
                      context.read<PostDetailPresenter>().onTappedCommentLikeButton(comment);
                    },
                  ),
                  canDelete: canDelete,
                  onDelete: () {
                    context.read<PostDetailPresenter>().onTappedDeleteCommentButton(comment);
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
                        canDelete: canDelete,
                        onDelete: () {
                          context.read<PostDetailPresenter>().onTappedDeleteCommentButton(reComment);
                        },
                      );
                    },
                  )
                ]
              ],
            );
          }),
      ],
    );
  }

  Widget _buildSlidableComment(CommentItem commentItem, {required bool canDelete, Function()? onDelete}) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: canDelete ? 0.4 : 0.2,
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

  Widget _buildBottomTextField() {
    return Container(
      padding: const EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 12),
      decoration:
          const BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20)), color: ColorStyles.white),
      child: TextField(
        controller: _textEditingController,
        maxLines: null,
        decoration: InputDecoration(
          hintText: '~ 님에게 댓글 추가..',
          hintStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray40),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            gapPadding: 8,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: ColorStyles.gray40),
            borderRadius: BorderRadius.all(Radius.circular(24)),
            gapPadding: 8,
          ),
          contentPadding: const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 8),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8, right: 8),
            child: ButtonFactory.buildOvalButton(
              onTapped: () {
                if (_textEditingController.text.isNotEmpty) {}
              },
              text: '전송',
              style: OvalButtonStyle.fill(
                color: ColorStyles.black,
                textColor: ColorStyles.white,
                size: OvalButtonSize.large,
              ),
            ),
          ),
          suffixIconConstraints: const BoxConstraints(maxHeight: 48, maxWidth: 63),
          constraints: const BoxConstraints(minHeight: 48, maxHeight: 112),
        ),
      ),
    );
  }

  showSortCriteriaBottomSheet({required bool isMine}) {
    showBarrierDialog(
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
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
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
          onTap: () {},
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray10))),
            child: Text(
              '샥제햐기',
              style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.red),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
          child: ButtonFactory.buildRoundedButton(
            onTapped: () {
              context.pop();
            },
            text: '닫기',
            style: RoundedButtonStyle.fill(
              color: ColorStyles.black,
              textColor: ColorStyles.white,
              size: RoundedButtonSize.xLarge,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildOthersBottomSheet() {
    return Wrap(
      direction: Axis.vertical,
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        GestureDetector(
          onTap: () {},
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
          onTap: () {},
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
          child: ButtonFactory.buildRoundedButton(
            onTapped: () {
              context.pop();
            },
            text: '닫기',
            style: RoundedButtonStyle.fill(
              color: ColorStyles.black,
              textColor: ColorStyles.white,
              size: RoundedButtonSize.xLarge,
            ),
          ),
        )
      ],
    );
  }
}
