import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CoffeeBeansRankingList extends StatelessWidget {
  final List<String> _coffeeBeansRank;
  final String _updatedAt;

  const CoffeeBeansRankingList({
    super.key,
    required List<String> coffeeBeansRank,
    required String updatedAt,
  })  : _coffeeBeansRank = coffeeBeansRank,
        _updatedAt = updatedAt;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('원두 랭킹', style: TextStyles.title02SemiBold),
              const SizedBox(width: 6),
              Text(
                _updatedAt,
                style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: List<Widget>.generate(
                    5,
                    (index) => Container(
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
                              index < _coffeeBeansRank.length ? _coffeeBeansRank[index] : '-',
                              style: TextStyles.captionMediumMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: List<Widget>.generate(
                    5,
                    (index) => Container(
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
                              index + 5 < _coffeeBeansRank.length ? _coffeeBeansRank[index + 5] : '-',
                              style: TextStyles.captionMediumMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
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
