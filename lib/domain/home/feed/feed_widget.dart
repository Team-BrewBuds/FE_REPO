import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/comment_button.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/like_button.dart';
import 'package:brew_buds/common/widgets/profile_image.dart';
import 'package:brew_buds/common/widgets/save_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class FeedWidget<Presenter extends FeedPresenter> extends StatelessWidget {
  final Future<void> Function() onGuest;
  final bool isGuest;
  final Future<void> Function(bool isPost, int id, User author) onTapComments;

  const FeedWidget({
    super.key,
    required this.isGuest,
    required this.onGuest,
    required this.onTapComments,
  });

  Future<void> onTappedCommentsButton(BuildContext context);

  Future<void> onTappedProfile(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Selector<Presenter, AuthorState>(
            selector: (context, presenter) => presenter.authorState,
            builder: (context, state, child) => buildProfile(
              context: context,
              imageUrl: state.imageUrl,
              nickname: state.nickname,
              createdAt: state.createdAt,
              viewCount: state.viewCount,
              isFollow: state.isFollow,
              isMine: state.isMine,
            ),
          ),
          buildBody(context),
          Selector<Presenter, BottomButtonState>(
            selector: (context, presenter) => presenter.bottomButtonState,
            builder: (context, state, child) => buildBottomButtons(
              context: context,
              likeCount: state.likeCount,
              isLiked: state.isLiked,
              commentsCount: state.commentsCount,
              isSaved: state.isSaved,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProfile({
    required BuildContext context,
    required String imageUrl,
    required String nickname,
    required String createdAt,
    required int viewCount,
    required bool isFollow,
    required bool isMine,
  }) {
    return ThrottleButton(
      onTap: () {
        if (isGuest) {
          onGuest.call();
        } else {
          onTappedProfile(context);
        }
      },
      child: Container(
        height: 36,
        margin: const EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //프로필 사진
            ProfileImage(imageUrl: imageUrl, height: 36, width: 36),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    //닉네임
                    child: Text(
                      nickname,
                      textAlign: TextAlign.start,
                      style: TextStyles.title01SemiBold,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      //작성 시간 및 조회수
                      '$createdAt・조희 $viewCount',
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
                  if (isGuest) {
                    return onGuest.call();
                  } else {
                    return context.read<Presenter>().onFollowButtonTap();
                  }
                },
                isFollowed: isFollow,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildBody(BuildContext context);

  Widget buildBottomButtons({
    required BuildContext context,
    required int likeCount,
    required bool isLiked,
    required int commentsCount,
    required bool isSaved,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 16),
      child: Row(
        children: [
          LikeButton(
            onTap: () {
              if (isGuest) {
                return onGuest.call();
              } else {
                return context.read<Presenter>().onLikeButtonTap();
              }
            },
            isLiked: isLiked,
            likeCount: likeCount,
          ),
          const SizedBox(width: 12),
          CommentButton(
            onTap: () {
              if (isGuest) {
                return onGuest.call();
              } else {
                return onTappedCommentsButton(context);
              }
            },
            commentCount: commentsCount,
          ),
          const Spacer(),
          SaveButton(
            onTap: () {
              if (isGuest) {
                return onGuest.call();
              } else {
                return context.read<Presenter>().onSaveButtonTap();
              }
            },
            isSaved: isSaved,
          ),
        ],
      ),
    );
  }
}
