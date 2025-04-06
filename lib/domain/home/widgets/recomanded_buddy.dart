import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/follow_button.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';

class RecommendedBuddyWidget extends StatelessWidget {
  final String imageUrl;
  final String nickName;
  final int followCount;
  final bool isFollowed;
  final Function() onTappedFollowButton;

  const RecommendedBuddyWidget({
    super.key,
    required this.imageUrl,
    required this.nickName,
    required this.followCount,
    required this.isFollowed,
    required this.onTappedFollowButton,
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
          MyNetworkImage(
            imageUrl: imageUrl,
            height: 80,
            width: 80,
            shape: BoxShape.circle,
          ),
          const SizedBox(height: 12),
          Text(
            nickName,
            style: TextStyles.labelSmallSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            '$followCount',
            style: TextStyles.labelSmallSemiBold,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          FollowButton(
            onTap: () async {
              onTappedFollowButton.call();
            },
            isFollowed: isFollowed,
          ),
        ],
      ),
    );
  }
}
