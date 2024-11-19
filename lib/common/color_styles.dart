import 'package:flutter/material.dart';

final class ColorStyles {
  ColorStyles._();

  static const Color background = Color(0xffFFF7F5);

  //Primary Colors
  static const Color black = Color(0xff000000);
  static const Color white = Color(0xffffffff);
  static const Color red = Color(0xffFE2E00);
  static const Color red10 =  Color(0xFFFE2D00);
  static const Color red20 =  Color(0xFFFF4412);
  static const Color orange =  Color(0xFFFF5C31);

  //Grayscale
  static const Color gray = Color(0xffFE2E00);
  static const Color gray90 = Color(0xff313131);
  static const Color gray80 = Color(0xff4F4F4F);
  static const Color gray70 = Color(0xff626262);
  static const Color gray60 = Color(0xff898989);
  static const Color gray50 = Color(0xffAAAAAA);
  static const Color gray40 = Color(0xffCFCFCF);
  static const Color gray30 = Color(0xffE1E1E1);
  static const Color gray20 = Color(0xffEEEEEE);
  static const Color gray10 = Color(0xffF7F7F7);

  //Opacity Black
  static Color black70 = const Color(0xff000000).withOpacity(0.7);
  static Color black50 = const Color(0xff000000).withOpacity(0.5);
  static Color black30 = const Color(0xff000000).withOpacity(0.3);

  //Opacity White
  static Color white70 = const Color(0xffffffff).withOpacity(0.7);
  static Color white50 = const Color(0xffffffff).withOpacity(0.5);
  static Color white30 = const Color(0xffffffff).withOpacity(0.3);
}
