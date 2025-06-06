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
  Widget Function(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  )? transitionBuilder,
}) {
  return showGeneralDialog<Result>(
    barrierLabel: "Barrier",
    barrierDismissible: true,
    barrierColor: barrierColor ?? ColorStyles.black50,
    transitionDuration: const Duration(milliseconds: 300),
    context: context,
    pageBuilder: pageBuilder,
    transitionBuilder: transitionBuilder ??
        (_, anim, __, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0)).animate(anim),
            child: child,
          );
        },
  );
}
