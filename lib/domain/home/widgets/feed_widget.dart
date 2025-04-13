import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_button.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/like_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/save_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:flutter/material.dart';

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
  final int likeCount;
  final int commentsCount;
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
          LikeButton(
            onTap: () {
              onTapLikeButton.call();
            },
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          const SizedBox(width: 12),
          CommentButton(
            onTap: () {
              onTapCommentsButton.call();
            },
            commentCount: commentsCount,
          ),
          const Spacer(),
          SaveButton(
            onTap: () {
              onTapSaveButton.call();
            },
            isSaved: isSaved,
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
