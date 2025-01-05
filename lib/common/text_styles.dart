import 'package:flutter/material.dart';

import 'color_styles.dart';

final class TextStyles {
  TextStyles._();

  //Title
  static const title05Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 28.8 / 24,
    letterSpacing: -0.01,
  );
  static const title04SemiBold = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 26.4 / 22,
    letterSpacing: -0.02,
  );
  static const title03SemiBold = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.w400,
    height: 25.2 / 21,
  );
  static const title02Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24 / 16,
    letterSpacing: -0.02,
  );
  static const title02SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16,
    height: 19.2 / 16,
    letterSpacing: -0.02,
  );
  static const titleMediumSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    height: 26.4 / 15,
    letterSpacing: -0.02,
  );
  static const title01Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14,
    height: 16.8 / 14,
    letterSpacing: -0.02,
  );
  static const title01SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14,
    height: 16.8 / 14,
    letterSpacing: -0.02,
  );

  //Label
  static const labelMediumMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    height: 16.8 / 14,
    letterSpacing: -0.01,
  );
  static const labelSmallSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13,
    height: 15.6 / 13,
    letterSpacing: -0.01,
  );
  static const labelSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13,
    height: 15.6 / 13,
  );

  static const bodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 19.5 / 13,
    letterSpacing: -0.01,
  );
  static const bodyNarrowRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 13,
    height: 16.9 / 13,
    letterSpacing: -0.02,
    color: ColorStyles.gray50
  );

  //Caption
  static const captionMediumSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12,
    height: 18 / 12,
  );
  static const captionMediumMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 18 / 12,
    letterSpacing: -0.01,
  );
  static const captionMediumNarrowMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 15.6 / 12,
    letterSpacing: -0.01,
  );
  static const captionMediumRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12,
    height: 14.4 / 12,
    letterSpacing: -0.01,
  );

  static const captionSmallSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10,
    height: 12 / 10,
  );
  static const captionSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10,
    height: 15 / 10,
  );
  static const captionSmallRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10,
    height: 15 / 10,
  );
  static const captionXSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 8,
    height: 12 / 8,
  );

  static const textlightRegular = TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 16,
      fontFamily: 'Pretendard',
      color: Color(0xFFAAAAAA),
      letterSpacing: -0.13);
}
