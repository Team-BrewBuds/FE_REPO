import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final void Function() onTap;

  const SendButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ThrottleButton(
      onTap: () {
        onTap.call();
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
