import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

class ThrottleButton extends StatelessWidget {
  final Throttle<bool> _throttle;
  final Function() onTap;
  final Widget child;

  ThrottleButton({
    super.key,
    required this.onTap,
    required this.child,
  }): _throttle = Throttle(
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
      child: child,
    );
  }
}
