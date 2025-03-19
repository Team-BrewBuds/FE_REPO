import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommentButton extends StatelessWidget {
  final void Function() onTap;
  final int commentCount;

  const CommentButton({
    super.key,
    required this.onTap,
    required this.commentCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/like.svg',
              width: 24,
              height: 24,
              colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
            ),
            Text(
              '댓글 $commentCount}',
              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
            )
          ],
        ),
      ),
    );
  }
}
