import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/factory/icon_button_factory.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class FeedWidget extends StatefulWidget {
  final int id;
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
    required this.id,
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
            MyNetworkImage(
              imageUri: widget.writerThumbnailUri,
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
                      widget.writerNickName,
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      //작성 시간 및 조회수
                      '${widget.writingTime}・${widget.hits}',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
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
    return InkWell(
      onTap: () {
        widget.onTapLikeButton();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.isLiked ? 'assets/icons/like.svg' : 'assets/icons/like.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              widget.isLiked ? ColorStyles.red : ColorStyles.gray70,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(widget.likeCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
          ),
        ],
      ),
    );
  }

  Widget buildCommentButton() {
    return InkWell(
      onTap: () {
        widget.onTapCommentsButton();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.isLeaveComment ? 'assets/icons/message_fill.svg' : 'assets/icons/message.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              widget.isLeaveComment ? ColorStyles.red : ColorStyles.gray70,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(widget.commentsCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return InkWell(
      onTap: () {
        widget.onTapSaveButton();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            widget.isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              widget.isSaved ? ColorStyles.red : ColorStyles.gray70,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text('저장', style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
          ),
        ],
      ),
    );
    return IconButtonFactory.buildHorizontalButtonWithIconWidget(
      iconWidget: SvgPicture.asset(
        widget.isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
        height: 24,
        width: 24,
        colorFilter: ColorFilter.mode(
          widget.isSaved ? ColorStyles.red : ColorStyles.gray70,
          BlendMode.srcIn,
        ),
      ),
      text: '저장',
      textStyle: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
      iconAlign: ButtonIconAlign.left,
      onTapped: widget.onTapSaveButton,
    );
  }
}
