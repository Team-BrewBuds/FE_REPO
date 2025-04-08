import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/material.dart';

class ThrottleButton extends StatelessWidget {
  final Throttle<void> _throttle;
  final Function() onTap;
  final Widget child;

  ThrottleButton({
    super.key,
    required this.onTap,
    required this.child,
  }): _throttle = Throttle(
    const Duration(seconds: 3),
    initialValue: null,
    checkEquality: false,
    onChanged: (value) {
      onTap.call();
    },
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _throttle.setValue(null);
      },
      child: child,
    );
  }
}
