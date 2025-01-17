import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/re_comments_list.dart';
import 'package:brew_buds/detail/etc_bottom_sheet.dart';
import 'package:brew_buds/home/widgets/post_feed/horizontal_image_list_view.dart';
import 'package:brew_buds/home/widgets/slider_view.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

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
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildTitle(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfile(),
            buildBody(),
            buildBottomButtons(),
            Container(
              height: 12,
              color: ColorStyles.gray20,
            ),
            _buildCommentTitle(),
            buildComments(),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: MediaQuery.of(context).viewInsets,
        child: _buildBottomTextField(),
      ),
    );
  }

  AppBar _buildTitle() {
    return AppBar(
      leadingWidth: 0,
      leading: SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            const Text('게시물', style: TextStyles.title02SemiBold),
            const Spacer(),
            InkWell(
              onTap: () {
                showSortCriteriaBottomSheet();
              },
              child: SvgPicture.asset(
                'assets/icons/more.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
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

  Widget _buildProfile() {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //프로필 사진
            Container(
              height: 36,
              width: 36,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: Color(0xffD9D9D9),
                shape: BoxShape.circle,
              ),
              child: Image.network(
                '',
                fit: BoxFit.cover,
                errorBuilder: (context, _, trace) => Container(),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    //닉네임
                    child: Text(
                      '커피의 신',
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      //작성 시간 및 조회수
                      '1시간전 ・ 조회 531',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            FollowButton(onTap: () {}, isFollowed: false),
          ],
        ),
      ),
    );
  }

  Widget buildBody() {
    final images = [
      'http://placeimg.com/640/480',
      'http://placeimg.com/640/480',
      'http://placeimg.com/640/480',
    ];
    return Column(
      children: [
        Visibility(
          visible: images.isNotEmpty,
          child: HorizontalImageListView(
            imagesUrl: images,
          ),
        ),
        _buildTextBody(),
      ],
    );
  }

  Widget _buildTextBody() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [_buildTag(), const Spacer()],
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            '벙커 컴퍼니',
            style: TextStyles.titleMediumSemiBold,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            '2년 전에 벙커 컴퍼니의 블랜딩을 처음 접했었다. 클린컵이 좋았으며, 부드러운 바디감과 전체적인 밸런스가 안정적이며, 호불호가 크지 않는 커피였었다. 그렇기에 이번에는 어떤 느낌일까 궁금했었고, 또한 지난번에는 에티오피아 콩가와 콜롬비아 보니타의 조합이었다면, 이번에는 같은 나라의 다른 농장의 커피를 사용하였다.',
            style: TextStyles.bodyRegular,
          ),
          const SizedBox(height: 12, width: double.infinity),
          Text(
            '#태그내용 #태그내용',
            style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red),
          ),
        ],
      ),
    );
  }

  Widget _buildTag() {
    final subject = PostSubject.beans;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: ColorStyles.black),
      child: Row(
        children: [
          SvgPicture.asset(
            subject.iconPath,
            colorFilter: ColorFilter.mode(
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

  Widget buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
      child: Row(
        children: [
          buildLikeButton(),
          const Spacer(),
          buildSaveButton(),
        ],
      ),
    );
  }

  Widget buildLikeButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '좋아요 53',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      onTapped: () {},
      iconAlign: ButtonIconAlign.left,
    );
  }

  Widget buildSaveButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        true ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          true ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      iconAlign: ButtonIconAlign.left,
      onTapped: () {},
    );
  }

  Widget _buildCommentTitle() {
    return Padding(
      padding: EdgeInsets.only(top: 16, left: 16, right: 16),
      child: Text(
        '댓글 23',
        style: TextStyles.title01SemiBold,
      ),
    );
  }

  Widget buildComments() {
    final List<Comment> commentDummy = [
      Comment(
        id: 1,
        author: User(id: 1, nickname: '커피에빠져죽고싶은', profileImageUri: ''),
        content: '이거 커피 맛있어요!',
        likeCount: 50,
        createdAt: '30분전',
        reComments: [],
        isLiked: false,
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(
        commentDummy.length,
        (index) {
          final comment = commentDummy[index];
          return Column(
            children: [
              _buildSlidableComment(
                CommentItem(
                  padding: comment.reComments.isEmpty
                      ? const EdgeInsets.all(16)
                      : const EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                  profileImageUri: comment.author.profileImageUri,
                  nickName: comment.author.nickname,
                  createdAt: comment.createdAt,
                  isWriter: false,
                  contents: comment.content,
                  isLiked: comment.isLiked,
                  likeCount: '${comment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                  canReply: true,
                  onTappedReply: () {},
                  onTappedLikeButton: () {},
                ),
              ),
              if (comment.reComments.isNotEmpty) ...[
                ReCommentsList(
                  reCommentsLength: comment.reComments.length,
                  reCommentsBuilder: (index) {
                    final reComment = comment.reComments[index];
                    return _buildSlidableComment(
                      CommentItem(
                        padding: const EdgeInsets.only(left: 60, right: 16, top: 12, bottom: 12),
                        profileImageUri: reComment.author.profileImageUri,
                        nickName: reComment.author.nickname,
                        createdAt: reComment.createdAt,
                        isWriter: true,
                        contents: reComment.content,
                        isLiked: reComment.isLiked,
                        likeCount: '${reComment.likeCount > 9999 ? '9999+' : comment.likeCount}',
                        onTappedLikeButton: () {},
                      ),
                    );
                  },
                )
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildSlidableComment(CommentItem commentItem) {
    return Slidable(
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        children: [
          Expanded(
            child: InkWell(
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
            child: InkWell(
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
      padding: EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 46),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: ColorStyles.gray20)), color: ColorStyles.white),
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

  showSortCriteriaBottomSheet() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (_, __, ___) {
        return EtcBottomSheet(
          items: [
            (
              '수정하기',
              ColorStyles.black,
              () {},
            ),
            (
              '삭제하기',
              ColorStyles.red,
              () {},
            )
          ],
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}
