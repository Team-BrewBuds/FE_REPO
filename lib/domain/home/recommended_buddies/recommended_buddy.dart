import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddy_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendedBuddyWidget extends StatelessWidget {
  const RecommendedBuddyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: ColorStyles.white,
        border: Border.all(color: ColorStyles.gray20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Builder(builder: (context) {
            final imageUrl = context.select<RecommendedBuddyPresenter, String>(
              (presenter) => presenter.user.profileImageUrl,
            );
            return MyNetworkImage(
              imageUrl: imageUrl,
              height: 80,
              width: 80,
              shape: BoxShape.circle,
            );
          }),
          const SizedBox(height: 12),
          Builder(builder: (context) {
            final nickname = context.select<RecommendedBuddyPresenter, String>(
              (presenter) => presenter.user.nickname,
            );
            return Text(
              nickname,
              style: TextStyles.labelSmallSemiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
          const SizedBox(height: 2),
          Builder(builder: (context) {
            final followerCount = context.select<RecommendedBuddyPresenter, int>(
              (presenter) => presenter.user.followerCount,
            );
            return Text(
              '$followerCount',
              style: TextStyles.labelSmallSemiBold,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            );
          }),
          const SizedBox(height: 12),
          Builder(
            builder: (context) {
              final isFollow = context.select<RecommendedBuddyPresenter, bool>(
                (presenter) => presenter.user.isFollow,
              );
              return FollowButton(
                onTap: () => context.read<RecommendedBuddyPresenter>().onTapFollow(),
                isFollowed: isFollow,
              );
            },
          ),
        ],
      ),
    );
  }
}
