import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchMainView extends StatelessWidget {
  final List<String> _recentSearchWordsDummy = ['게샤 워시드', '에티오피아', 'G1', '예카체프', '원두추천'];
  final _recommendedCoffeeBeansDummy = [
    ('에티오피아 사다모 G2 워시드', 4.9, 74),
    ('에티오피아 예가 체프 G1', 4.8, 220),
    ('케냐 예가체프 G1 워시드', 4.3, 52),
    ('케냐 예가체프 G1 허니', 4.5, 2120),
  ];
  final List<String> _coffeeBeansRankingDummy = [
    '과테말라 안티구아',
    '콜롬비아 후일라 수프리모',
    '에티오피아 예가체프 G4',
    '싱글 케냐 AA Plus 아이히더 워시드',
    '에티오피아 아리차 예가체프 G1 내추럴',
    '에티오피아 구지 시다모 G1',
    '브라질 세하도 FC NY2 내추럴',
    '코스타리카 따라주 SHB 워시드',
    '에티오피아 사다모 G2 워시드',
    '에티오피아 사다모 G2 워시드',
  ];

  SearchMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildRecentSearchWordsList(),
        const SizedBox(height: 28),
        _buildRecommendedCoffeeBeansList(),
        const SizedBox(height: 28),
        Expanded(child: _buildCoffeeBeansRankingList()),
      ],
    );
  }

  Widget _buildRecentSearchWordsList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              const Text('최근 검색어', style: TextStyles.title02SemiBold),
              const Spacer(),
              InkWell(
                onTap: () {},
                child: Text('모두 지우기', style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50)),
              )
            ],
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _recentSearchWordsDummy
                .map<Widget>(
                  (word) => Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    decoration: BoxDecoration(
                        border: Border.all(color: ColorStyles.gray70),
                        borderRadius: const BorderRadius.all(Radius.circular(20))),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(word, style: TextStyles.captionMediumRegular),
                        const SizedBox(width: 2),
                        InkWell(
                          onTap: () {},
                          child: SvgPicture.asset('assets/icons/x.svg', height: 14, width: 14),
                        ),
                      ],
                    ),
                  ),
                )
                .separator(separatorWidget: const SizedBox(width: 6))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedCoffeeBeansList() {
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
            children: _recommendedCoffeeBeansDummy
                .map<Widget>(
                  (bean) => SizedBox(
                    width: 109,
                    child: Column(
                      children: [
                        Container(
                          height: 109,
                          width: 109,
                          color: const Color(0xffd9d9d9),
                          child: Image.network(
                            '',
                            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          bean.$1,
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
                              '${bean.$2} (${bean.$3})',
                              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                .separator(separatorWidget: const SizedBox(width: 8))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildCoffeeBeansRankingList() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 26),
      child: Column(
        children: [
          Row(
            children: [
              const Text('원두 랭킹', style: TextStyles.title02SemiBold),
              const SizedBox(width: 6),
              Text(
                '10.27 16:00 업데이트',
                style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray50),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: List<Widget>.generate(
                2,
                (index) {
                  final startIndex = index * 5;
                  final endIndex = ((index + 1) * 5);
                  return Expanded(
                    child: Column(
                      children: _coffeeBeansRankingDummy.sublist(startIndex, endIndex).indexed.map<Widget>(
                        (indexed) {
                          return Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                border: Border(bottom: BorderSide(color: ColorStyles.gray20, width: 0.5)),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '${indexed.$1 + startIndex + 1}',
                                    style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.red),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      indexed.$2,
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
                      ).toList(),
                    ),
                  );
                },
              ).separator(separatorWidget: const SizedBox(width: 8)).toList(),
            ),
          )
        ],
      ),
    );
  }
}
