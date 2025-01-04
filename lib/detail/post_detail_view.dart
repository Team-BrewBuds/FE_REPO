import 'package:brew_buds/common/factory/button_factory.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/comment_item.dart';
import 'package:brew_buds/common/widgets/comments_widget.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostDetailView extends StatefulWidget {
  const PostDetailView({super.key});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  late final TextEditingController _textEditingController;

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
            _buildCommentsListView(),
          ],
        ),
      ),
      bottomSheet: _buildBottomTextField(),
    );
  }

  AppBar _buildTitle() {
    return AppBar(
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColorStyles.gray20))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {},
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
              onTap: () {},
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
    final Widget? contents = null;
    if (contents != null) {
      return Column(
        children: [
          contents,
          _buildTextBody(),
        ],
      );
    } else {
      return _buildTextBody();
    }
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

  Widget _buildCommentsListView() {
    final Comment commentDummy = Comment(
      id: 1,
      author: User(id: 1, nickname: '커피에빠져죽고싶은', profileImageUri: ''),
      content: '이거 커피 맛있어요!',
      likeCount: 50,
      createdAt: '30분전',
      reComments: [],
      isLiked: false,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List<Widget>.generate(
        23,
        (index) {
          return Slidable(
            endActionPane: ActionPane(
              motion: DrawerMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  icon: Icons.archive,
                  label: 'Archive',
                ),
                SlidableAction(
                  onPressed: (context) {},
                  backgroundColor: Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  icon: Icons.save,
                  label: 'Save',
                ),
              ],
            ),
            child: CommentsWidget(
              commentItem: CommentItem(
                padding: commentDummy.reComments.isEmpty
                    ? EdgeInsets.all(16)
                    : EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 8),
                profileImageUri: commentDummy.author.profileImageUri,
                nickName: commentDummy.author.nickname,
                createdAt: commentDummy.createdAt,
                isWriter: commentDummy.author.id == 1,
                contents: commentDummy.content,
                isLiked: commentDummy.isLiked,
                likeCount: '${commentDummy.likeCount > 9999 ? '9999+' : commentDummy.likeCount}',
                onTappedLikeButton: () {},
              ),
              subCommentsLength: 0,
              subCommentsBuilder: (int index) {
                final reComment = commentDummy.reComments[index];
                return CommentItem(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  profileImageUri: reComment.author.profileImageUri,
                  nickName: reComment.author.nickname,
                  createdAt: reComment.createdAt,
                  isWriter: 1 == reComment.author.id,
                  contents: reComment.content,
                  isLiked: reComment.isLiked,
                  likeCount: '${reComment.likeCount > 9999 ? '9999+' : reComment.likeCount}',
                  onTappedLikeButton: () {},
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomTextField() {
    return Container(
      padding: EdgeInsets.only(top: 12, right: 16, left: 16, bottom: 46),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: ColorStyles.gray20)),
        color: ColorStyles.white
      ),
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
}
