import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastingRecordItemWidget extends StatelessWidget {
  final String imageUri;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: MyNetworkImage(
            imageUri: imageUri,
            height: double.infinity,
            width: double.infinity,
            color: const Color(0xffD9D9D9),
          ),
        ),
        Positioned(
          left: 6,
          bottom: 6.5,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/star_fill.svg',
                height: 18,
                width: 18,
                colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
              ),
              const SizedBox(width: 4),
              Text(
                '$rating',
                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  const TastingRecordItemWidget({
    super.key,
    required this.imageUri,
    required this.rating,
  });
}
