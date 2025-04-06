import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LikeButton extends StatelessWidget {
  final Throttle<bool> _throttle;
  final void Function() onTap;
  final bool isLiked;
  final int likeCount;

  LikeButton({
    super.key,
    required this.onTap,
    required this.isLiked,
    required this.likeCount,
  }) : _throttle = Throttle(
    const Duration(seconds: 3),
    initialValue: false,
    onChanged: (value) {
      if (value) {
        onTap.call();
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _throttle.setValue(true);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (isLiked)
              SvgPicture.asset(
                'assets/icons/like_fill.svg',
                width: 24,
                height: 24,
              )
            else
              SvgPicture.asset(
                'assets/icons/like.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
              ),
            Text(
              '좋아요 $likeCount',
              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
            )
          ],
        ),
      ),
    );
  }
}
