import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class CustomIconTextRow extends StatelessWidget {
  final String iconPath; // 아이콘 경로
  final String title; // 텍스트
  final String content;
  final double iconWidth; // 아이콘 너비
  final double iconHeight; // 아이콘 높이
  final MainAxisAlignment mainAxisAlignment; // 정렬 방식

  // 생성자
  const CustomIconTextRow({
    Key? key,
    required this.iconPath,
    required this.title,
    required this.content,
    this.iconWidth = 24,
    this.iconHeight = 24,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          iconPath, // 아이콘 경로
          width: iconWidth, // 아이콘 너비
          height: iconHeight, // 아이콘 높이
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0,horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, textAlign: TextAlign.left,style: TextStyles.title01SemiBold, ),
              Text(content, style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray50),),
            ],
          ),
        )
     // 텍스트
      ],
    );
  }
}