import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/icon_button_factory.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/widgets/follow_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class FeedWidget extends StatefulWidget {
  final String writerThumbnailUri;
  final String writerNickName;
  final String writingTime;
  final String hits;
  final bool isFollowed;
  final void Function() onTapProfile;
  final void Function() onTapFollowButton;
  final bool isLiked;
  final String likeCount;
  final bool isLeaveComment;
  final String commentsCount;
  final bool isSaved;
  final void Function() onTapLikeButton;
  final void Function() onTapCommentsButton;
  final void Function() onTapSaveButton;

  const FeedWidget({
    super.key,
    required this.writerThumbnailUri,
    required this.writerNickName,
    required this.writingTime,
    required this.hits,
    required this.isFollowed,
    required this.onTapProfile,
    required this.onTapFollowButton,
    required this.isLiked,
    required this.likeCount,
    required this.isLeaveComment,
    required this.commentsCount,
    required this.isSaved,
    required this.onTapLikeButton,
    required this.onTapCommentsButton,
    required this.onTapSaveButton,
  });

  @override
  FeedWidgetState createState();
}

abstract class FeedWidgetState<T extends FeedWidget> extends State<T> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildProfile(),
          buildBody(),
          buildBottomButtons(),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return InkWell(
      onTap: widget.onTapProfile,
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
              child: Image.network(widget.writerThumbnailUri, fit: BoxFit.cover),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    //닉네임
                    child: Text(
                      widget.writerNickName,
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      //작성 시간 및 조회수
                      '${widget.writingTime}・${widget.hits}',
                      style: TextStyles.labelSmallRegular.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(width: 8),
            FollowButton(onTap: widget.onTapFollowButton, isFollowed: widget.isFollowed),
          ],
        ),
      ),
    );
  }

  Widget buildBody();

  Widget buildBottomButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
      child: Row(
        children: [
          buildLikeButton(),
          const SizedBox(width: 6),
          buildCommentButton(),
          const Spacer(),
          buildSaveButton(),
        ],
      ),
    );
  }

  Widget buildLikeButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        widget.isLiked ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
        colorFilter: ColorFilter.mode(
          widget.isLiked ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: widget.likeCount,
      onTapped: widget.onTapLikeButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }

  Widget buildCommentButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        widget.isLeaveComment ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
        colorFilter: ColorFilter.mode(
          widget.isLeaveComment ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: widget.commentsCount,
      onTapped: widget.onTapCommentsButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }

  Widget buildSaveButton() {
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        widget.isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        colorFilter: ColorFilter.mode(
          widget.isSaved ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      onTapped: widget.onTapSaveButton,
      style: const IconButtonStyle(textColor: ColorStyles.gray70, iconAlign: ButtonIconAlign.left),
    );
  }
}
