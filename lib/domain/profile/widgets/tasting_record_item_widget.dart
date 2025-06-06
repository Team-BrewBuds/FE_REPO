import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TastingRecordItemWidget extends StatelessWidget {
  final String imageUrl;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: LayoutBuilder(builder: (context, constraints) {
            return MyNetworkImage(
              imageUrl: imageUrl,
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              showGradient: true,
            );
          }),
        ),
        Positioned(
          left: 6,
          bottom: 6.5,
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/icons/star_fill.svg',
                height: 14,
                width: 14,
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
    required this.imageUrl,
    required this.rating,
  });
}
