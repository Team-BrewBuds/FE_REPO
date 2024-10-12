import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconButtonStyle {
  final Color textColor;
  final ButtonIconAlign iconAlign;

  const IconButtonStyle({
    this.textColor = ColorStyles.white,
    required this.iconAlign,
  });
}

enum ButtonIconAlign { left, right }

final class IconButtonFactory {
  IconButtonFactory._();

  static Widget buildHorizontalButtonWithIcon({
    required IconData iconData,
    required String text,
    required Function() onTapped,
    required IconButtonStyle style,
  }) {
    return InkWell(
      onTap: onTapped,
      child: Row(
        children: switch (style.iconAlign) {
          ButtonIconAlign.left => [
              Icon(iconData, color: style.textColor, size: 18),
              Text(text, style: TextStyles.labelMediumMedium.copyWith(color: style.textColor)),
            ],
          ButtonIconAlign.right => [
              Text(text, style: TextStyles.labelMediumMedium.copyWith(color: style.textColor)),
              Icon(iconData, color: style.textColor, size: 18),
            ],
        },
      ),
    );
  }

  static Widget buildHorizontalButtonWithIconWidget({
    required Widget iconWidget,
    required String text,
    required Function() onTapped,
    required IconButtonStyle style,
  }) {
    return InkWell(
      onTap: onTapped,
      child: Row(
        children: switch (style.iconAlign) {
          ButtonIconAlign.left => [
              SizedBox(height: 24, width: 24, child: iconWidget),
              Text(text, style: TextStyles.labelMediumMedium.copyWith(color: style.textColor)),
            ],
          ButtonIconAlign.right => [
              Text(text, style: TextStyles.labelMediumMedium.copyWith(color: style.textColor)),
              SizedBox(height: 24, width: 24, child: iconWidget),
            ],
        },
      ),
    );
  }

  static Widget buildVerticalButtonWithIconWidget({
    required Widget iconWidget,
    required String text,
    required Function() onTapped,
    required Color color,
  }) {
    return InkWell(
      onTap: onTapped,
      child: SizedBox(
        height: 49,
        width: 36,
        child: Stack(
          children: [
            Positioned(top: 14, left: 16, right: 16, child: SizedBox(height: 18, width: 18, child: iconWidget)),
            Positioned(bottom: 0, child: Text(text, style: TextStyles.captionMediumMedium.copyWith(color: color))),
          ],
        ),
      ),
    );
  }
}
