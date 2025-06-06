import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LikeButton extends StatelessWidget {
  final Future<void> Function() onTap;
  final bool isLiked;
  final int likeCount;

  const LikeButton({
    super.key,
    required this.onTap,
    required this.isLiked,
    required this.likeCount,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton(
      onTap: () => onTap.call(),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            if (isLiked)
              SvgPicture.asset(
                'assets/icons/like_fill.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
              )
            else
              SvgPicture.asset(
                'assets/icons/like.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                '좋아요 ${likeCount > 999 ? '999+' : likeCount}',
                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
              ),
            )
          ],
        ),
      ),
    );
  }
}
