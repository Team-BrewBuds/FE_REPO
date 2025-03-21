import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoffeeBeanResultsItem extends StatelessWidget {
  final String _beanName;
  final double _rating;
  final int _recordCount;
  final String _imageUri;

  const CoffeeBeanResultsItem({
    super.key,
    required String beanName,
    required double rating,
    required int recordCount,
    required String imageUri,
  })  : _beanName = beanName,
        _rating = rating,
        _recordCount = recordCount,
        _imageUri = imageUri;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _beanName,
                  style: TextStyles.labelMediumMedium,
                ),
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
                      '$_rating ($_recordCount)',
                      style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                    ),
                    const Spacer(),
                  ],
                ),
              ],
            ),
          ),
          if (_imageUri.isNotEmpty) ...[
            const SizedBox(width: 8),
            MyNetworkImage(imageUrl: _imageUri, height: 64, width: 64),
          ],
        ],
      ),
    );
  }
}
