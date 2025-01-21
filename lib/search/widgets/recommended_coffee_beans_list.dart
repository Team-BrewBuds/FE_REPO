import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef RecommendedCoffeeBeansItem = (
  String imgaeUri,
  String name,
  double rating,
  int commentsCount,
  void Function() onTapped,
);

class RecommendedCoffeeBeansList extends StatelessWidget {
  final int _itemLength;
  final RecommendedCoffeeBeansItem Function(int index) _itemBuilder;

  const RecommendedCoffeeBeansList({
    super.key,
    required int itemLength,
    required RecommendedCoffeeBeansItem Function(int index) itemBuilder,
  })  : _itemLength = itemLength,
        _itemBuilder = itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text('추천 원두', style: TextStyles.title02SemiBold),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List<Widget>.generate(
              _itemLength,
              (index) {
                final item = _itemBuilder(index);
                return InkWell(
                  onTap: () {
                    item.$5();
                  },
                  child: SizedBox(
                    width: 109,
                    child: Column(
                      children: [
                        Container(
                          height: 109,
                          width: 109,
                          color: const Color(0xffd9d9d9),
                          child: Image.network(
                            item.$1,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.$2,
                          style: TextStyles.captionMediumSemiBold,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
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
                              '${item.$3} (${item.$4})',
                              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ).separator(separatorWidget: const SizedBox(width: 8)).toList(),
          ),
        ),
      ],
    );
  }
}
