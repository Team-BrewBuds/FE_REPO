import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUri;
  final double height;
  final double width;
  final Color color;
  final BoxShape? shape;

  @override
  Widget build(BuildContext context) {
    return imageUri.isEmpty
        ? Container(
            height: height,
            width: width,
            decoration: BoxDecoration(color: color, shape: shape ?? BoxShape.rectangle),
          )
        : ExtendedImage.network(
            imageUri,
            height: height,
            width: width,
            shape: shape,
            fit: BoxFit.cover,
            printError: false,
          );
  }

  const MyNetworkImage({
    super.key,
    required this.imageUri,
    required this.height,
    required this.width,
    required this.color,
    this.shape,
  });
}
