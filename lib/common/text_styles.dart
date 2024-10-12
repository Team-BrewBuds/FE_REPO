import 'package:flutter/material.dart';

final class TextStyles {
  TextStyles._();

  //HeadLine
  static const headlineLargeBold = TextStyle(fontWeight: FontWeight.w700, fontSize: 24);

  //Title
  static const title02Bold = TextStyle(fontWeight: FontWeight.w700, fontSize: 16);
  static const titleLargeSemiBold = TextStyle(fontWeight: FontWeight.w600, fontSize: 16);
  static const titleMediumSemiBold = TextStyle(fontWeight: FontWeight.w600, fontSize: 15);
  static const titleSmallBold = TextStyle(fontWeight: FontWeight.w700, fontSize: 14);

  //Label
  static const labelMediumRegular = TextStyle(fontWeight: FontWeight.w400, fontSize: 13);
  static const labelMediumMedium = TextStyle(fontWeight: FontWeight.w500, fontSize: 13);
  static const labelSmallRegular = TextStyle(fontWeight: FontWeight.w400, fontSize: 12);
  static const labelSmallMedium = TextStyle(fontWeight: FontWeight.w500, fontSize: 12);
  static const labelSmallSemiBold = TextStyle(fontWeight: FontWeight.w600, fontSize: 12);

  //Text
  static const textMediumRegular = TextStyle(fontWeight: FontWeight.w400, fontSize: 13);

  static const captionMediumMedium = TextStyle(fontWeight: FontWeight.w500, fontSize: 12);
  static const captionXSmallMedium = TextStyle(fontWeight: FontWeight.w500, fontSize: 8);
}
