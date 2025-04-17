import 'package:flutter/material.dart';

class FutureButton<T> extends StatelessWidget {
  final ValueNotifier<bool> _isProcessingNotifier = ValueNotifier(false);
  final Future<T> Function() onTap;
  final void Function()? onError;
  final void Function(T)? onComplete;
  final Widget child;

  FutureButton({
    super.key,
    required this.onTap,
    required this.child,
    this.onError,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _isProcessingNotifier,
      builder: (context, isProcessing, _) {
        return AbsorbPointer(
          absorbing: isProcessing,
          child: GestureDetector(
            onTap: () async {
              try {
                _isProcessingNotifier.value = true;
                final result = await onTap();
                onComplete?.call(result);
              } catch (e) {
                onError?.call();
              } finally {
                if (context.mounted) _isProcessingNotifier.value = false;
              }
            },
            child: child,
          ),
        );
      },
    );
  }
}
