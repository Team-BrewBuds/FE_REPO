import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveButton extends StatelessWidget {
  final void Function() onTap;
  final bool isSaved;

  const SaveButton({
    super.key,
    required this.onTap,
    required this.isSaved,
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
              colorFilter: ColorFilter.mode(isSaved ? ColorStyles.red : ColorStyles.gray70, BlendMode.srcIn),
            ),
            Text(
              '저장',
              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
            )
          ],
        ),
      ),
    );
  }
}
