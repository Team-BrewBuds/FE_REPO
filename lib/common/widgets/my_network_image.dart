import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxShape? shape;
  final BoxBorder? border;
  final bool showGradient;

  const MyNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.shape,
    this.border,
    this.showGradient = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = imageUrl.isNotEmpty
        ? ExtendedImage.network(
            imageUrl,
            height: height,
            width: width,
            shape: shape,
            border: border,
            fit: BoxFit.cover,
            printError: false,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return null;
                case LoadState.completed:
                  return null;
                case LoadState.failed:
                  return _buildPlaceholder();
              }
            },
          )
        : _buildPlaceholder();

    return showGradient
        ? Stack(
            children: [
              imageWidget,
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: height / 2,
                // 하단 절반 정도만 그라데이션 적용
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromRGBO(0, 0, 0, 0.0), // opacity 0%
                        Color.fromRGBO(0, 0, 0, 0.5), // opacity 50%
                        Color.fromRGBO(0, 0, 0, 0.8), // opacity 80%
                      ],
                      stops: [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ],
          )
        : imageWidget;
  }

  Widget _buildPlaceholder() {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xffd9d9d9),
        shape: shape ?? BoxShape.rectangle,
        border: border,
      ),
    );
  }
}
