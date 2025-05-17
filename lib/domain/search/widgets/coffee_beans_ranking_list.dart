import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_simple.dart';
import 'package:flutter/material.dart';

class CoffeeBeansRankingList extends StatelessWidget {
  final List<CoffeeBeanSimple> _coffeeBeansRank;

  const CoffeeBeansRankingList({
    super.key,
    required List<CoffeeBeanSimple> coffeeBeansRank,
  }) : _coffeeBeansRank = coffeeBeansRank;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('원두 랭킹', style: TextStyles.title02SemiBold),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final coffeeBean = _coffeeBeansRank.elementAtOrNull(index);
                      return GestureDetector(
                        onTap: () {
                          if (coffeeBean != null) {
                            ScreenNavigator.showCoffeeBeanDetail(context: context, id: coffeeBean.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${index + 1}',
                                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  coffeeBean?.name ?? '-',
                                  style: TextStyles.captionMediumMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final coffeeBean = _coffeeBeansRank.elementAtOrNull(index + 5);
                      return GestureDetector(
                        onTap: () {
                          if (coffeeBean != null) {
                            ScreenNavigator.showCoffeeBeanDetail(context: context, id: coffeeBean.id);
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const BoxDecoration(
                            border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 0.5)),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${index + 6}',
                                style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  coffeeBean?.name ?? '-',
                                  style: TextStyles.captionMediumMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
