import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CoffeeBeanResultsItem extends StatelessWidget {
  final String _beanName;
  final double _rating;
  final int _recordCount;

  const CoffeeBeanResultsItem({
    super.key,
    required String beanName,
    required double rating,
    required int recordCount,
  })  : _beanName = beanName,
        _rating = rating,
        _recordCount = recordCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
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
    );
  }
}
