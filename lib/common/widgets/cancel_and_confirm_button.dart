import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:flutter/material.dart';

class CancelAndConfirmButton extends StatelessWidget {
  final void Function() onCancel;
  final void Function() onConfirm;
  final Widget cancelButtonChild;
  final String confirmText;
  final bool isValid;

  const CancelAndConfirmButton({
    super.key,
    required this.onCancel,
    required this.onConfirm,
    required this.cancelButtonChild,
    required this.confirmText,
    required this.isValid,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ThrottleButton(
            onTap: () {
              onCancel.call();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration:
                  const BoxDecoration(color: ColorStyles.gray30, borderRadius: BorderRadius.all(Radius.circular(8))),
              child: cancelButtonChild,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: AbsorbPointer(
            absorbing: !isValid,
            child: ThrottleButton(
              onTap: () {
                onConfirm.call();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                    color: isValid ? ColorStyles.black : ColorStyles.gray20,
                    borderRadius: const BorderRadius.all(Radius.circular(8))),
                child: Text(
                  confirmText,
                  style: TextStyles.labelMediumMedium.copyWith(color: isValid ? ColorStyles.white : ColorStyles.gray40),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
