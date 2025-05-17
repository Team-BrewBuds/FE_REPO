import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/exception/comments_exception.dart';
import 'package:flutter/material.dart';

class SendButton extends StatelessWidget {
  final Future<void> Function() onTap;
  final void Function(String message) onError;
  final void Function() onComplete;

  const SendButton({
    super.key,
    required this.onTap,
    required this.onError,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return FutureButton<void, CommentException>(
      onTap: () => onTap.call(),
      onError: (exception) {
        onError.call(exception.toString());
      },
      onComplete: (_) {
        onComplete.call();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(color: Colors.black, borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Text(
          '전송',
          style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
