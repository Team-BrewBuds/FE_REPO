import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavedCoffeeBeanWidget extends StatelessWidget {
  final String name;
  final String rating;
  final int tastedRecordsCount;
  final String imageUri;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  name,
                  style: TextStyles.labelMediumMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/star_fill.svg',
                      height: 14,
                      width: 14,
                      colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${rating} (${tastedRecordsCount})',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          MyNetworkImage(
            imageUri: imageUri,
            height: 64,
            width: 64,
            color: const Color(0xffD9D9D9),
          ),
        ],
      ),
    );
  }

  const SavedCoffeeBeanWidget({
    super.key,
    required this.name,
    required this.rating,
    required this.tastedRecordsCount,
    required this.imageUri,
  });
}
