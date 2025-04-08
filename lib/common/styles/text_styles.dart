import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

final class TextStyles {
  TextStyles._();

  //Title
  static TextStyle title05Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 24.sp,
    height: 1.2,
    letterSpacing: -0.01,
  );
  static TextStyle title04SemiBold = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.02,
  );
  static TextStyle title03SemiBold = TextStyle(
    fontSize: 21.sp,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );
  static TextStyle title02Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 16.sp,
    height: 1.5,
    letterSpacing: -0.02,
  );
  static TextStyle title02SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.sp,
    height: 1.2,
    letterSpacing: -0.02,
  );
  static TextStyle title01Bold = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 14.sp,
    height: 16.8 / 14,
    letterSpacing: -0.02,
  );
  static TextStyle title01SemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 14.sp,
    height: 1.2,
    letterSpacing: -0.02,
  );

  //Label
  static TextStyle labelMediumMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14.sp,
    height: 1.2,
    letterSpacing: -0.01,
  );
  static TextStyle labelSmallSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 13.sp,
    height: 1.2,
    letterSpacing: -0.01,
  );
  static TextStyle labelSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 13.sp,
    height: 1.2,
  );

  static TextStyle bodyRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1.5,
    letterSpacing: -0.01,
  );
  static TextStyle bodyNarrowRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 14.sp,
    height: 1.3,
    letterSpacing: -0.02,
  );

  //Caption
  static TextStyle captionMediumSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 12.sp,
    height: 1.5,
  );
  static TextStyle captionMediumMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 1.5,
    letterSpacing: -0.01,
  );
  static TextStyle captionMediumNarrowMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12.sp,
    height: 1.3,
    letterSpacing: -0.01,
  );
  static TextStyle captionMediumRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 12.sp,
    height: 1.2,
    letterSpacing: -0.01,
  );

  static TextStyle captionSmallSemiBold = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 10.sp,
    height: 1.2,
  );
  static TextStyle captionSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 10.sp,
    height: 1.5,
  );
  static TextStyle captionSmallRegular = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 10.sp,
    height: 1.5,
  );
  static TextStyle captionXSmallMedium = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 8.sp,
    height: 1.5,
  );
}
