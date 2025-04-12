import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract class FeedWidget extends StatelessWidget {
  final int id;
  final int writerId;
  final String writerThumbnailUrl;
  final String writerNickName;
  final String writingTime;
  final String hits;
  final bool isFollowed;
  final void Function() onTapProfile;
  final void Function() onTapFollowButton;
  final bool isLiked;
  final String likeCount;
  final String commentsCount;
  final bool isSaved;
  final void Function() onTapLikeButton;
  final void Function() onTapCommentsButton;
  final void Function() onTapSaveButton;

  const FeedWidget({
    super.key,
    required this.id,
    required this.writerId,
    required this.writerThumbnailUrl,
    required this.writerNickName,
    required this.writingTime,
    required this.hits,
    required this.isFollowed,
    required this.onTapProfile,
    required this.onTapFollowButton,
    required this.isLiked,
    required this.likeCount,
    required this.commentsCount,
    required this.isSaved,
    required this.onTapLikeButton,
    required this.onTapCommentsButton,
    required this.onTapSaveButton,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildProfile(),
          buildBody(context),
          buildBottomButtons(),
        ],
      ),
    );
  }

  Widget buildProfile() {
    return ThrottleButton(
      onTap: () {
        onTapProfile.call();
      },
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //프로필 사진
            MyNetworkImage(
              imageUrl: writerThumbnailUrl,
              height: 36,
              width: 36,
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
                      writerNickName,
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      //작성 시간 및 조회수
                      '$writingTime・$hits',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                    ),
                  )
                ],
              ),
            ),
            if (AccountRepository.instance.id != writerId) ...[
              const SizedBox(width: 8),
              FollowButton(onTap: onTapFollowButton, isFollowed: isFollowed),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context);

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
    return ThrottleButton(
      onTap: () {
        onTapLikeButton.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isLiked ? 'assets/icons/like_fill.svg' : 'assets/icons/like.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isLiked ? ColorStyles.red : ColorStyles.gray70,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(likeCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
          ),
        ],
      ),
    );
  }

  Widget buildCommentButton() {
    return ThrottleButton(
      onTap: () {
        onTapCommentsButton.call();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/message.svg',
            height: 24,
            width: 24,
            colorFilter: const ColorFilter.mode(
              ColorStyles.gray70,
              BlendMode.srcIn,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Text(commentsCount, style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70)),
          ),
        ],
      ),
    );
  }

  Widget buildSaveButton() {
    return ThrottleButton(
      onTap: () {
        onTapSaveButton();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            isSaved ? 'assets/icons/save_fill.svg' : 'assets/icons/save.svg',
            height: 24,
            width: 24,
            colorFilter: ColorFilter.mode(
              isSaved ? ColorStyles.red : ColorStyles.gray70,
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
  }

  showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black90,
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
