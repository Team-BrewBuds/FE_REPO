import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';

class TagStyle {
  final Color backgroundColor;
  final Color textColor;
  final TagSize size;
  final double opacity;
  final TagIconAlign iconAlign;

  const TagStyle({
    this.backgroundColor = ColorStyles.black,
    this.textColor = ColorStyles.white,
    required this.size,
    this.opacity = 1.0,
    required this.iconAlign,
  });
}

enum TagIconAlign { left, right }

class TagSize {
  final Size iconSize;
  final double spacing;
  final EdgeInsets padding;
  final TextStyle textStyle;

  const TagSize._({
    required this.iconSize,
    required this.spacing,
    required this.padding,
    required this.textStyle,
  });

  static TagSize medium = const TagSize._(
    iconSize: Size(16, 16),
    spacing: 2,
    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 12),
    textStyle: TextStyles.labelSmallSemiBold,
  );

  static TagSize small = const TagSize._(
    iconSize: Size(16, 16),
    spacing: 2,
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    textStyle: TextStyles.labelSmallSemiBold,
  );

  static TagSize xSmall = const TagSize._(
    iconSize: Size(10, 10),
    spacing: 0,
    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
    textStyle: TextStyles.captionXSmallMedium,
  );
}

final class TagFactory {
  TagFactory._();

  static Widget buildTag({required Widget icon, required String text, required TagStyle style}) {
    return Container(
      padding: style.size.padding,
      decoration: BoxDecoration(
        color: style.backgroundColor.withOpacity(style.opacity),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: switch (style.iconAlign) {
          TagIconAlign.left => [
              SizedBox(
                height: style.size.iconSize.height,
                width: style.size.iconSize.width,
                child: FittedBox(fit: BoxFit.cover, child: icon),
              ),
              SizedBox(width: style.size.spacing),
              Text(text, style: style.size.textStyle.copyWith(color: style.textColor)),
            ],
          TagIconAlign.right => [
              Text(text, style: style.size.textStyle.copyWith(color: style.textColor)),
              SizedBox(width: style.size.spacing),
              SizedBox(
                height: style.size.iconSize.height,
                width: style.size.iconSize.width,
                child: FittedBox(fit: BoxFit.cover, child: icon),
              ),
            ],
        },
      ),
    );
  }
}
