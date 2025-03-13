import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class MyNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final Color? color;
  final BoxShape? shape;
  final BoxBorder? border;

  @override
  Widget build(BuildContext context) {
    return imageUrl.isEmpty
        ? Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              shape: shape ?? BoxShape.rectangle,
              border: border
            ),
          )
        : ExtendedImage.network(
            imageUrl,
            height: height,
            width: width,
            shape: shape,
            border: border,
            fit: BoxFit.cover,
            printError: false,
          );
  }

  const MyNetworkImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.color,
    this.shape,
    this.border,
  });
}
