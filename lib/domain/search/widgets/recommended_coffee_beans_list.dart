import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

typedef RecommendedCoffeeBeansItem = ({
  String imgaeUrl,
  String name,
  double rating,
  int recordCount,
  void Function() onTapped,
});

class RecommendedCoffeeBeansList extends StatelessWidget {
  final int _itemLength;
  final bool _isLoading;
  final RecommendedCoffeeBeansItem Function(int index) _itemBuilder;

  const RecommendedCoffeeBeansList({
    super.key,
    required int itemLength,
    required bool isLoading,
    required RecommendedCoffeeBeansItem Function(int index) itemBuilder,
  })  : _itemLength = itemLength,
        _isLoading = isLoading,
        _itemBuilder = itemBuilder;

  @override
  Widget build(BuildContext context) {
    return !_isLoading && _itemLength == 0
        ? const SizedBox.shrink()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('추천 원두', style: TextStyles.title02SemiBold),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 153,
                child: _isLoading
                    ? const Center(child: CupertinoActivityIndicator())
                    : ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          final item = _itemBuilder(index);
                          return GestureDetector(
                            onTap: () {
                              item.onTapped.call();
                            },
                            child: SizedBox(
                              width: 109,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  if (item.imgaeUrl.isNotEmpty)
                                    MyNetworkImage(imageUrl: item.imgaeUrl, height: 109, width: 109)
                                  else
                                    Container(height: 109, width: 109, color: const Color(0xffd9d9d9)),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.name,
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
                                        '${item.rating} (${item.recordCount})',
                                        style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(width: 8),
                        itemCount: _itemLength,
                      ),
              ),
              const SizedBox(height: 28),
            ],
          );
  }
}
