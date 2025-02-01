import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

final class ButtonFactory {
  ButtonFactory._();

  static Widget buildOvalButton(
      {required Function() onTapped,
      required String text,
      required OvalButtonStyle style}) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        padding: style.size.padding,
        decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            )),
        child: Text(
          text,
          style: style.size.textStyle.copyWith(color: style.textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget buildRoundedButton(
      {required Function() onTapped,
      required String text,
      required RoundedButtonStyle style}) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        width: style.size.width,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
        decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            )),
        child: Text(
          text,
          style: TextStyles.labelMediumMedium.copyWith(color: style.textColor),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static Widget buildButton(
      {required Function() onTapped,
        required String text,
         String ? iconPath,
        required RoundedButtonStyle style}) {
    return InkWell(
      onTap: onTapped,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
            color: style.backgroundColor,
            borderRadius: BorderRadius.circular(0),
            border: Border.all(
              color: style.borderColor,
              width: style.borderWidth,
            )),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if(iconPath != null)
            SvgPicture.asset(
              iconPath,
              fit: BoxFit.scaleDown,
              height: 28,
              width: 28,
              color: ColorStyles.gray50,
            ),
            Text(
              text,
              style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
            ),

          ]
        ),
      ),
    );
  }
}

class OvalButtonStyle {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final OvalButtonSize size;

  const OvalButtonStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.size,
    required this.borderWidth,
  });

  factory OvalButtonStyle.fill({
    Color color = ColorStyles.gray30,
    Color textColor = ColorStyles.gray70,
    required OvalButtonSize size,
  }) =>
      OvalButtonStyle(
        backgroundColor: color,
        borderColor: Colors.transparent,
        borderWidth: 0,
        textColor: textColor,
        size: size,
      );

  factory OvalButtonStyle.line(
          {required Color color,
          required Color textColor,
          required OvalButtonSize size}) =>
      OvalButtonStyle(
        backgroundColor: Colors.transparent,
        borderColor: color,
        borderWidth: 1,
        textColor: textColor,
        size: size,
      );

  factory OvalButtonStyle.disabled({required OvalButtonSize size}) =>
      OvalButtonStyle(
        backgroundColor: ColorStyles.gray50,
        borderColor: Colors.transparent,
        borderWidth: 0,
        textColor: ColorStyles.white,
        size: size,
      );
}

class OvalButtonSize {
  final EdgeInsets padding;
  final TextStyle textStyle;

  const OvalButtonSize._({
    required this.padding,
    required this.textStyle,
  });

  static OvalButtonSize xLarge = const OvalButtonSize._(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
    textStyle: TextStyles.labelMediumMedium,
  );

  static OvalButtonSize large = const OvalButtonSize._(
    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    textStyle: TextStyles.labelSmallMedium,
  );

  static OvalButtonSize medium = const OvalButtonSize._(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
    textStyle: TextStyles.labelMediumMedium,
  );

  static OvalButtonSize small = const OvalButtonSize._(
    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    textStyle: TextStyles.captionMediumMedium,
  );
}

class RoundedButtonStyle {
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final Color textColor;
  final RoundedButtonSize size;

  const RoundedButtonStyle({
    required this.backgroundColor,
    required this.borderWidth,
    required this.borderColor,
    required this.textColor,
    required this.size,
  });

  factory RoundedButtonStyle.fill({
    Color color = ColorStyles.gray50,
    Color textColor = ColorStyles.white,
    required RoundedButtonSize size,
  }) =>
      RoundedButtonStyle(
        backgroundColor: color,
        borderWidth: 0,
        borderColor: Colors.transparent,
        textColor: textColor,
        size: size,
      );

  factory RoundedButtonStyle.line({
    Color color = ColorStyles.gray50,
    Color textColor = ColorStyles.gray50,
    Color backgroundColor = Colors.transparent,
    required RoundedButtonSize size,
  }) =>
      RoundedButtonStyle(
        backgroundColor: backgroundColor,
        borderWidth: 1,
        borderColor: color,
        textColor: textColor,
        size: size,
      );

  factory RoundedButtonStyle.disabled(
          {required RoundedButtonSize size, required BorderRadius radius}) =>
      RoundedButtonStyle(
        backgroundColor: ColorStyles.gray30,
        borderWidth: 0,
        borderColor: Colors.transparent,
        textColor: ColorStyles.gray70,
        size: size,
      );

  factory RoundedButtonStyle.disabled02(
      {required RoundedButtonSize size, required BorderRadius radius}) =>
      RoundedButtonStyle(
        backgroundColor: ColorStyles.background,
        borderWidth: 0,
        borderColor: Colors.transparent,
        textColor: ColorStyles.gray70,
        size: size,
      );
}

class RoundedButtonSize {
  final double width;

  const RoundedButtonSize._({required this.width});

  static RoundedButtonSize xLarge = const RoundedButtonSize._(width: 343);

  static RoundedButtonSize large = const RoundedButtonSize._(width: 251);

  static RoundedButtonSize medium = const RoundedButtonSize._(width: 167.5);

  static RoundedButtonSize small = const RoundedButtonSize._(width: 152);

  static RoundedButtonSize xSmall = const RoundedButtonSize._(width: 84);

  static RoundedButtonSize xxSmall = const RoundedButtonSize._(width: 58);

  static RoundedButtonSize bW288H48 = const RoundedButtonSize._(width: 288);

  static RoundedButtonSize bW129H47 = const RoundedButtonSize._(width: 100.5);
}

class NextButtonStyle {}
