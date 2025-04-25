import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class CustomCircleCropLayerPainter extends EditorCropLayerPainter {
  @override
  void paintMask(Canvas canvas, Rect rect, ExtendedImageCropLayerPainter painter) {
    final paint = Paint()..color = ColorStyles.black30;
    final path = Path()..addRect(rect);

    path.addOval(Rect.fromCircle(
      center: painter.cropRect.center,
      radius: painter.cropRect.size.width * 0.49, // 원 크기 조절
    ));

    path.fillType = PathFillType.evenOdd; // 내부 원을 투명하게 만듦
    canvas.drawPath(path, paint);
  }

  @override
  void paintCorners(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {}

  @override
  void paintLines(Canvas canvas, Size size, ExtendedImageCropLayerPainter painter) {
    if (!painter.pointerDown) return;

    final rect = painter.cropRect;
    final radius = rect.size.width * 0.49;
    final center = rect.center;

    // 1. 원형 경로 생성
    final Path circlePath = Path()..addOval(Rect.fromCircle(center: center, radius: radius));

    // 2. 캔버스를 원으로 clip
    canvas.save(); // 현재 상태 저장
    canvas.clipPath(circlePath); // 이후 그리기는 원 안에서만 발생

    final Paint paint = Paint()
      ..color = ColorStyles.black30
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    final double thirdWidth = rect.width / 3;
    final double thirdHeight = rect.height / 3;

    // 수직선 2개
    for (int i = 1; i < 3; i++) {
      final dx = rect.left + thirdWidth * i;
      canvas.drawLine(Offset(dx, rect.top), Offset(dx, rect.bottom), paint);
    }

    // 수평선 2개
    for (int i = 1; i < 3; i++) {
      final dy = rect.top + thirdHeight * i;
      canvas.drawLine(Offset(rect.left, dy), Offset(rect.right, dy), paint);
    }

    canvas.restore(); // 클리핑 해제
  }
}
