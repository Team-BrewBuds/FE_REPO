import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SavedCoffeeBeanWidget extends StatelessWidget {
  final String name;
  final String rating;
  final int tastedRecordsCount;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
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
                      '$rating ($tastedRecordsCount)',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          if (imagePath.isNotEmpty) ...[
            const SizedBox(width: 24),
            ExtendedImage.asset(
              imagePath,
              height: 64,
              width: 64,
            ),
          ],
        ],
      ),
    );
  }

  const SavedCoffeeBeanWidget({
    super.key,
    required this.name,
    required this.rating,
    required this.tastedRecordsCount,
    required this.imagePath,
  });
}
