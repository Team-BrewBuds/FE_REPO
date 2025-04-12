import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';

class CustomCameraButton extends StatefulWidget {
  final CameraState state;
  final Function(CaptureRequest) onCaptureSuccess;

  const CustomCameraButton({
    super.key,
    required this.state,
    required this.onCaptureSuccess,
  });

  @override
  State<CustomCameraButton> createState() => _CustomCameraButtonState();
}

class _CustomCameraButtonState extends State<CustomCameraButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late double _scale;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 78,
        height: 78,
        child: CustomPaint(
          painter: CaptureButtonPainter(innerCircleScale: _scale),
        ),
      ),
    );
  }

  _onTapDown(TapDownDetails details) {
    _animationController.forward();
  }

  _onTapUp(TapUpDetails details) {
    Future.delayed(const Duration(milliseconds: 100), () {
      _animationController.reverse().then((_) {
        onTap.call();
      });
    });
  }

  _onTapCancel() {
    _animationController.reverse();
  }

  get onTap => () {
        widget.state.when(
          onPhotoMode: (photoState) => photoState.takePhoto().then((value) {
            widget.onCaptureSuccess.call(value);
          }),
        );
      };
}

class CaptureButtonPainter extends CustomPainter {
  final double innerCircleScale; // 내부 원 크기 조절을 위한 변수

  CaptureButtonPainter({required this.innerCircleScale});

  @override
  void paint(Canvas canvas, Size size) {
    final double outerRadius = size.width / 2;
    final double innerRadius = outerRadius * 0.85 * innerCircleScale; // 애니메이션 적용

    final Paint outerCirclePaint = Paint()
      ..color = const Color(0xFFD9D9D9) // 바깥 원 (연한 회색)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final Paint innerCirclePaint = Paint()
      ..color = const Color(0xFFD9D9D9) // 안쪽 원 (더 연한 회색)
      ..style = PaintingStyle.fill;

    // 중앙 좌표
    final Offset center = Offset(size.width / 2, size.height / 2);

    // 바깥 원 그리기
    canvas.drawCircle(center, outerRadius, outerCirclePaint);

    // 안쪽 원 그리기 (애니메이션 적용)
    canvas.drawCircle(center, innerRadius, innerCirclePaint);
  }

  @override
  bool shouldRepaint(CaptureButtonPainter oldDelegate) => oldDelegate.innerCircleScale != innerCircleScale;
}
