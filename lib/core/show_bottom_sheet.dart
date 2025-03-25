import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:flutter/material.dart';

Future<Result?> showBarrierDialog<Result>({
  required BuildContext context,
  Color? barrierColor,
  required Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) pageBuilder,
}) {
  return showGeneralDialog<Result>(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: barrierColor ?? ColorStyles.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: pageBuilder,
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
