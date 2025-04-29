import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final Future<void> Function() onTap;
  final bool isFollowed;

  const FollowButton({
    super.key,
    required this.onTap,
    required this.isFollowed,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => onTap.call(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: isFollowed ? ColorStyles.gray30 : ColorStyles.red,
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Text(
          isFollowed ? '팔로잉' : '팔로우',
          style: TextStyles.labelSmallMedium.copyWith(color: isFollowed ? ColorStyles.black : ColorStyles.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
