import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

class ProfileImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final BoxBorder? border;

  const ProfileImage({
    super.key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl.isNotEmpty
        ? ExtendedImage.network(
            imageUrl,
            height: height,
            width: width,
            shape: BoxShape.circle,
            fit: BoxFit.cover,
            border: border,
            printError: false,
            cache: true,
            cacheRawData: true,
            clearMemoryCacheWhenDispose: false,
            loadStateChanged: (state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return null;
                case LoadState.completed:
                  return null;
                case LoadState.failed:
                  return ExtendedImage.asset(
                    'assets/images/profile/default_profile.png',
                    height: height,
                    width: width,
                    shape: BoxShape.circle,
                    fit: BoxFit.cover,
                  );
              }
            },
          )
        : ExtendedImage.asset(
            'assets/images/profile/default_profile.png',
            height: height,
            width: width,
            shape: BoxShape.circle,
            fit: BoxFit.cover,
            border: border,
          );
  }
}
