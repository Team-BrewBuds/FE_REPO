import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SaveButton extends StatelessWidget {
  final Throttle<bool> _throttle;
  final void Function() onTap;
  final bool isSaved;

  SaveButton({
    super.key,
    required this.onTap,
    required this.isSaved,
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
            if (isSaved)
              SvgPicture.asset(
                'assets/icons/save_fill.svg',
                width: 24,
                height: 24,
              )
            else
              SvgPicture.asset(
                'assets/icons/save.svg',
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(ColorStyles.gray70, BlendMode.srcIn),
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
