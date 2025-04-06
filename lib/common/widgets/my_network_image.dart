import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxShape? shape;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {

    return imageUrl.isNotEmpty ? ExtendedImage.network(
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
      },
    ) : Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: const Color(0xffd9d9d9),
        shape: shape ?? BoxShape.rectangle,
        border: border,
      ),
    );
  }

  const MyNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.shape,
    this.border,
  });
}
