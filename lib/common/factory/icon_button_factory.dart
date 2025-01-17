import 'package:flutter/material.dart';

enum ButtonIconAlign { left, right }

final class IconButtonFactory {
  IconButtonFactory._();

  static Widget buildHorizontalButtonWithIcon({
    required Icon icon,
    required String text,
    required TextStyle textStyle,
    required Function() onTapped,
    required ButtonIconAlign iconAlign,
  }) {
    return InkWell(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: switch (iconAlign) {
            ButtonIconAlign.left => [
                icon,
                Text(text, style: textStyle),
              ],
            ButtonIconAlign.right => [
                Text(text, style: textStyle),
                icon,
              ],
          },
        ),
      ),
    );
  }

  static Widget buildHorizontalButtonWithIconWidget({
    required Widget iconWidget,
    required String text,
    required TextStyle textStyle,
    required Function() onTapped,
    required ButtonIconAlign iconAlign,
  }) {
    return InkWell(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: switch (iconAlign) {
            ButtonIconAlign.left => [
              iconWidget,
              Text(text, style: textStyle),
            ],
            ButtonIconAlign.right => [
              Text(text, style: textStyle),
              iconWidget,
            ],
          },
        ),
      ),
    );
  }

  static Widget buildVerticalButtonWithIconWidget({
    required Widget iconWidget,
    required String text,
    required TextStyle textStyle,
    required Function() onTapped,
  }) {
    return InkWell(
      onTap: onTapped,
      child: Padding(
        padding: const EdgeInsets.only(top: 14, left: 6, right: 6),
        child: Column(
          children: [
            Center(child: iconWidget),
            SizedBox(height: 2),
            Text(text, style: textStyle),
          ],
        ),
      ),
    );
  }
}
