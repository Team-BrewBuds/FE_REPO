import 'dart:math';

import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/domain/detail/coffee_bean/coffee_bean_detail_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_screen.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_widget.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoffeeBeanDetailScreen extends StatefulWidget {
  const CoffeeBeanDetailScreen({super.key});

  @override
  State<CoffeeBeanDetailScreen> createState() => _CoffeeBeanDetailScreenState();
}

class _CoffeeBeanDetailScreenState extends State<CoffeeBeanDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CoffeeBeanDetailPresenter>().initState();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Selector<CoffeeBeanDetailPresenter, BeanInfoState>(
                selector: (context, presenter) => presenter.beanInfoState,
                builder: (context, state, child) => _buildBeanInformation(
                  name: state.name,
                  rating: state.rating,
                  type: state.type,
                  isDecaf: state.isDecaf,
                  imageUrl: state.imageUrl,
                  flavors: state.flavors,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 12, right: 12, bottom: 48),
                padding: const EdgeInsets.only(top: 20, bottom: 24, left: 16, right: 16),
                color: ColorStyles.gray10,
                child: Column(
                  children: [
                    Selector<CoffeeBeanDetailPresenter, BeanDetailState>(
                      selector: (context, presenter) => presenter.beanDetailState,
                      builder: (context, state, child) => _buildBeanDetail(
                        country: state.country,
                        region: state.region,
                        variety: state.variety,
                        process: state.process,
                        roastPoint: state.roastPoint,
                        roastery: state.roastery,
                        extraction: state.extraction,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Selector<CoffeeBeanDetailPresenter, BeanTasteState>(
                      selector: (context, presenter) => presenter.beanTasteState,
                      builder: (context, state, child) => _buildTastingGraph(
                        bodyValue: state.body,
                        acidityValue: state.acidity,
                        acerbityValue: state.bitterness,
                        sweetnessValue: state.sweetness,
                      ),
                    ),
                  ],
                ),
              ),
              Container(height: 8, color: ColorStyles.gray20),
              Selector<CoffeeBeanDetailPresenter, List<TopFlavor>>(
                selector: (context, presenter) => presenter.topFlavors,
                builder: (context, topFlavors, child) => _buildTopFlavors(topFlavors: topFlavors),
              ),
              Selector<CoffeeBeanDetailPresenter, DefaultPage<TastedRecordInCoffeeBean>>(
                selector: (context, presenter) => presenter.page,
                builder: (context, page, child) => _buildTastedRecords(
                  count: page.count,
                  tastedRecords: page.results,
                ),
              ),
              Container(height: 8, color: ColorStyles.gray20),
              Selector<CoffeeBeanDetailPresenter, List<RecommendedCoffeeBean>>(
                selector: (context, presenter) => presenter.recommendedCoffeeBeanList,
                builder: (context, recommendedCoffeeBeanList, child) => _buildRecommendedCoffeeBeans(
                  recommendedCoffeeBeans: recommendedCoffeeBeanList,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Selector<CoffeeBeanDetailPresenter, String>(
                selector: (context, presenter) => presenter.name,
                builder: (context, name, child) => Text(
                  name,
                  style: TextStyles.title02SemiBold,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size(double.infinity, 1),
        child: Container(
          width: double.infinity,
          height: 1,
          color: ColorStyles.gray20,
        ),
      ),
    );
  }

  Widget _buildBeanInformation({
    required String name,
    required double rating,
    required String type,
    required bool isDecaf,
    required String imageUrl,
    required List<String> flavors,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        _buildRatingWidget(rating: rating),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: 1,
                          height: 10,
                          color: ColorStyles.gray30,
                        ),
                        Expanded(
                          child: Text(
                            isDecaf ? '$type (디카페인)' : type,
                            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      name,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, letterSpacing: -0.02),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              MyNetworkImage(imageUrl: imageUrl, height: 80, width: 80),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: flavors
                  .map(
                    (flavor) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: ColorStyles.black.withOpacity(0.7),
                      ),
                      child: Text(
                        flavor,
                        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
                      ),
                    ),
                  )
                  .separator(separatorWidget: const SizedBox(width: 4))
                  .toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRatingWidget({required double rating}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/icons/star_fill.svg',
          width: 14,
          height: 14,
          colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
        ),
        const SizedBox(width: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2),
          child: Text(
            '$rating',
            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
          ),
        )
      ],
    );
  }

  Widget _buildBeanDetail({
    String? country,
    String? region,
    String? variety,
    String? process,
    String? roastPoint,
    String? roastery,
    String? extraction,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          '원두 상세정보',
          style: TextStyles.title02SemiBold,
        ),
        const SizedBox(height: 20),
        ...[
          _buildDetailItem(title: '생산 국가', content: country),
          _buildDetailItem(title: '원산지', content: region),
          _buildDetailItem(title: '품종', content: variety),
          _buildDetailItem(title: '가공방식', content: process),
          _buildDetailItem(title: '로스팅 포인트', content: roastPoint),
          _buildDetailItem(title: '로스터리', content: roastery),
          _buildDetailItem(title: '추출방식', content: extraction),
        ].separator(separatorWidget: const SizedBox(height: 13))
      ],
    );
  }

  Widget _buildDetailItem({required String title, String? content}) {
    return content != null
        ? Row(
            children: [
              Text(title, style: TextStyles.labelMediumMedium),
              Expanded(child: Text(content, style: TextStyles.labelMediumMedium, textAlign: TextAlign.right)),
            ],
          )
        : const SizedBox.shrink();
  }

  Widget _buildTastingGraph({
    required int bodyValue,
    required int acidityValue,
    required int acerbityValue,
    required int sweetnessValue,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('테이스팅', style: TextStyles.title02SemiBold),
        const SizedBox(height: 24),
        _buildTasteSlider(minText: '트로피칼', maxText: '무거운', value: bodyValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '산미약한', maxText: '산미강한', value: acidityValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '쓴맛약한', maxText: '쓴맛강한', value: acerbityValue),
        const SizedBox(height: 20),
        _buildTasteSlider(minText: '단맛약한', maxText: '단맛강한', value: sweetnessValue),
      ],
    );
  }

  Widget _buildTasteSlider({required String minText, required String maxText, required int value}) {
    final activeStyle = TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red);
    final inactiveStyle = TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60);
    return SizedBox(
      height: 16,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(
            width: 46,
            child: Text(
              minText,
              textAlign: TextAlign.center,
              style: value < 3 ? activeStyle : inactiveStyle,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final barWidth = (constraints.maxWidth - 12) / 4;
                  return Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                            const SizedBox(width: 4),
                            Expanded(child: Container(height: 2, color: const Color(0xFFD9D9D9))),
                          ],
                        ),
                      ),
                      if (value == 1)
                        Positioned(
                          left: 0 - 7,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        )
                      else if (value == 5)
                        Positioned(
                          right: 0 - 7,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        )
                      else if (value > 1 && value < 5)
                        Positioned(
                          left: (barWidth * (value - 1)) + ((value - 2) * 4) - 5,
                          child: Container(
                            width: 14,
                            height: 14,
                            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 46,
            child: Text(
              maxText,
              textAlign: TextAlign.center,
              style: value > 3 ? activeStyle : inactiveStyle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopFlavors({required List<TopFlavor> topFlavors}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('이 원두에서 많이 느낀 맛 TOP 3', style: TextStyles.title02SemiBold),
          const SizedBox(height: 24),
          ...List.generate(
            min(3, topFlavors.length),
            (index) => _buildTopFlavorItem(
              rank: index + 1,
              flavor: topFlavors[index].flavor,
              percent: topFlavors[index].percent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopFlavorItem({required int rank, required String flavor, required int percent}) {
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Row(
            children: [
              Text('$rank',
                  style: TextStyles.title05Bold.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray50)),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  flavor,
                  style:
                      TextStyles.labelSmallSemiBold.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray50),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Container(
            height: 12,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: ColorStyles.gray20,
            ),
            clipBehavior: Clip.hardEdge,
            child: Row(
              children: [
                Expanded(
                  flex: percent,
                  child: Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: ColorStyles.red,
                    ),
                  ),
                ),
                Spacer(flex: 100 - percent),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 32,
          child: Text(
            '$percent%',
            style: TextStyles.labelSmallSemiBold.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray50),
          ),
        ),
      ],
    );
  }

  Widget _buildTastedRecords({required int count, required List<TastedRecordInCoffeeBean> tastedRecords}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text('시음기록', style: TextStyles.title02SemiBold),
              const SizedBox(width: 2),
              Text('($count)', style: TextStyles.captionMediumSemiBold),
              const Spacer(),
            ],
          ),
          ...[
            const SizedBox(height: 24),
            ...List<Widget>.generate(
              min(4, tastedRecords.length),
              (index) {
                final tastedRecord = tastedRecords[index];
                return TastedRecordInCoffeeBeanWidget(
                  authorNickname: tastedRecord.nickname,
                  rating: tastedRecord.rating.toDouble(),
                  flavors: tastedRecord.flavors,
                  imageUrl: tastedRecord.photoUrl,
                  contents: tastedRecord.contents,
                );
              },
            ),
          ],
          if (count > 4) ...[
            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                final id = context.read<CoffeeBeanDetailPresenter>().id;
                final name = context.read<CoffeeBeanDetailPresenter>().name;
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return buildTastedRecordInCoffeeBeanListScreen(name: name, id: id);
                    },
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorStyles.gray50),
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(child: Text('시음기록 더보기', style: TextStyles.labelMediumMedium)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRecommendedCoffeeBeans({required List<RecommendedCoffeeBean> recommendedCoffeeBeans}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 104),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text('추천 원두', style: TextStyles.title02SemiBold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: recommendedCoffeeBeans
                  .map((recommendedCoffeeBean) => _buildRecommendedCoffeeBean(recommendedCoffeeBean))
                  .separator(separatorWidget: const SizedBox(width: 8))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCoffeeBean(RecommendedCoffeeBean recommendedCoffeeBean) {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 109,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MyNetworkImage(imageUrl: recommendedCoffeeBean.imageUrl, height: 109, width: 109),
            const SizedBox(height: 4),
            Text(
              recommendedCoffeeBean.name,
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
                  '${recommendedCoffeeBean.rating} (${recommendedCoffeeBean.recordCount})',
                  style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray70),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
