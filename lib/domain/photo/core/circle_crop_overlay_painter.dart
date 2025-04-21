import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:flutter/material.dart';

class CircleCropOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = ColorStyles.black70;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    // 원형 크롭 영역 만들기
    path.addOval(Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width * 0.49, // 원 크기 조절
    ));

    path.fillType = PathFillType.evenOdd; // 내부 원을 투명하게 만듦
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
