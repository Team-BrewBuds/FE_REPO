import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final Throttle<bool> _throttle;
  final void Function() onTap;

  SendButton({
    super.key,
    required this.onTap,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(20))
        ),
        child: Text(
          '전송',
          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
