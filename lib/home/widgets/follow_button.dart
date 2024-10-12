import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  final void Function() onTap;
  final bool isFollowed;

  const FollowButton({
    super.key,
    required this.onTap,
    required this.isFollowed,
  });

  @override
  Widget build(BuildContext context) {
    return ButtonFactory.buildOvalButton(
      onTapped: onTap,
      text: isFollowed ? '팔로잉' : '팔로우',
      style: isFollowed
          ? OvalButtonStyle.fill(color: ColorStyles.gray20, textColor: ColorStyles.gray80, size: OvalButtonSize.large)
          : OvalButtonStyle.line(color: ColorStyles.red, textColor: ColorStyles.red, size: OvalButtonSize.large),
    );
  }
}
