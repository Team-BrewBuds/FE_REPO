import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class TextButtonStyle {
  final Color textColor;
  final TextButtonSize size;

  TextButtonStyle({
    this.textColor = ColorStyles.gray50,
    required this.size,
  });

  factory TextButtonStyle.active({
    required TextButtonSize size,
  }) =>
      TextButtonStyle(
        textColor: ColorStyles.black,
        size: size,
      );
}

class TextButtonSize {
  final EdgeInsets padding;
  final TextStyle textStyle;

  const TextButtonSize._({
    required this.padding,
    required this.textStyle,
  });

  static TextButtonSize medium = const TextButtonSize._(
    padding: EdgeInsets.all(8),
    textStyle: TextStyles.title02SemiBold,
  );

  static TextButtonSize small = const TextButtonSize._(
    padding: EdgeInsets.zero,
    textStyle: TextStyles.labelSmallSemiBold,
  );
}

final class TextButtonFactory {
  TextButtonFactory._();

  static Widget build({
    required Function() onTapped,
    required TextButtonStyle style,
    required String text,
    bool isActive = false,
  }) {
    final currentStyle = isActive ? TextButtonStyle.active(size: style.size) : style;
    return InkWell(
      onTap: () {
        onTapped();
      },
      child: Container(
        padding: currentStyle.size.padding,
        child: isActive
            ? Column(
                children: [
                  Text(text, style: currentStyle.size.textStyle.copyWith(color: currentStyle.textColor)),
                  const SizedBox(height: 2),
                  Container(height: 2, color: currentStyle.textColor),
                ],
              )
            : Text(
                text,
                style: currentStyle.size.textStyle.copyWith(color: currentStyle.textColor),
              ),
      ),
    );
  }
}
