import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/my_network_image.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/core/snack_bar_mixin.dart';
import 'package:brew_buds/domain/detail/coffee_bean/coffee_bean_detail_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/tasted_record_in_coffee_bean_list_screen.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_presenter.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_widget.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/detail/widget/bean_detail.dart';
import 'package:brew_buds/domain/detail/widget/taste_graph.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoffeeBeanDetailScreen extends StatefulWidget {
  const CoffeeBeanDetailScreen({super.key});

  static Widget buildWithPresenter({required int id}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CoffeeBeanDetailPresenter>(create: (_) => CoffeeBeanDetailPresenter(id: id)),
        ChangeNotifierProvider<TastedRecordInCoffeeBeanListPresenter>(
          create: (_) => TastedRecordInCoffeeBeanListPresenter(id: id),
        ),
      ],
      child: const CoffeeBeanDetailScreen(),
    );
  }

  @override
  State<CoffeeBeanDetailScreen> createState() => _CoffeeBeanDetailScreenState();
}

class _CoffeeBeanDetailScreenState extends State<CoffeeBeanDetailScreen> with SnackBarMixin<CoffeeBeanDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Selector<CoffeeBeanDetailPresenter, bool>(
        selector: (context, presenter) => presenter.isEmpty,
        builder: (context, isEmpty, child) {
          if (isEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              showEmptyDialog().then((value) => context.pop());
            });
          }
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
                            builder: (context, state, child) => BeanDetail(
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
                            builder: (context, state, child) => TasteGraph(
                              bodyValue: state.body,
                              acidityValue: state.acidity,
                              bitternessValue: state.bitterness,
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
                    Selector<TastedRecordInCoffeeBeanListPresenter, List<TastedRecordInCoffeeBeanPresenter>>(
                      selector: (context, presenter) => presenter.previewPresenters,
                      builder: (context, presenters, child) => _buildTastedRecords(presenters: presenters),
                    ),
                    Selector<TastedRecordInCoffeeBeanListPresenter, bool>(
                      selector: (context, presenter) => presenter.presenters.length > 4,
                      builder: (context, hasMoreData, child) =>
                      hasMoreData ? _buildMoreTastedRecordsButton() : const SizedBox.shrink(),
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
            bottomNavigationBar: SafeArea(
              child: Selector<CoffeeBeanDetailPresenter, bool>(
                selector: (context, presenter) => presenter.isSaved,
                builder: (context, isSaved, child) => _buildBottomButtons(isSaved: isSaved),
              ),
            ),
          );
        });
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
            ThrottleButton(
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

  Widget _buildBottomButtons({required bool isSaved}) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 24),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: ThrottleButton(
                onTap: () {
                  context.read<CoffeeBeanDetailPresenter>().onTapSave().then((_) {
                    showSnackBar(message: isSaved ? '저장된 원두정보를 삭제했어요.' : '원두 정보를 저장했어요.');
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: ColorStyles.gray30,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isSaved)
                        SvgPicture.asset(
                          'assets/icons/save_fill.svg',
                          width: 18,
                          height: 18,
                        )
                      else
                        SvgPicture.asset(
                          'assets/icons/save.svg',
                          width: 18,
                          height: 18,
                          colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                        ),
                      Text('저장', style: TextStyles.labelMediumMedium)
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: ThrottleButton(
                onTap: () {
                  ScreenNavigator.showTastedRecordWriteScreen(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                  decoration: const BoxDecoration(
                    color: ColorStyles.black,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    '시음기록 작성하기',
                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ],
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
        spacing: 8,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  spacing: 4,
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
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.w600,
                        letterSpacing: -0.02,
                      ),
                      maxLines: null,
                    ),
                  ],
                ),
              ),
              MyNetworkImage(imageUrl: imageUrl, height: 80, width: 80),
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 4,
              children: flavors
                  .sublist(0, min(flavors.length, 4))
                  .map(
                    (flavor) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        color: ColorStyles.black70,
                      ),
                      child: Text(
                        flavor,
                        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.white),
                      ),
                    ),
                  )
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

  Widget _buildTopFlavors({required List<TopFlavor> topFlavors}) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 24, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('이 원두에서 많이 느낀 맛 TOP 3', style: TextStyles.title02SemiBold),
          const SizedBox(height: 24),
          if (topFlavors.isNotEmpty)
            ...List.generate(
              min(3, topFlavors.length),
              (index) => _buildTopFlavorItem(
                rank: index + 1,
                flavor: topFlavors[index].flavor,
                percent: topFlavors[index].percent.toInt(),
              ),
            )
          else ...[
            const SizedBox(height: 32),
            Text('아직 작성된 시음기록이 없어요.', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '버디님이 제일 먼저 시음 기록을 작성해보는 건 어때요?',
              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopFlavorItem({required int rank, required String flavor, required int percent}) {
    return Row(
      children: [
        SizedBox(
          width: 90.w,
          child: Row(
            children: [
              SizedBox(
                width: 20,
                child: Text(
                  '$rank',
                  style: TextStyles.title05Bold.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray50),
                ),
              ),
              const SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  flavor,
                  style: TextStyles.labelSmallSemiBold.copyWith(
                    color: rank == 1 ? ColorStyles.red : ColorStyles.gray50,
                  ),
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

  Widget _buildTastedRecords({required List<TastedRecordInCoffeeBeanPresenter> presenters}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('시음기록', style: TextStyles.title02SemiBold),
              const SizedBox(width: 2),
              Text('(${presenters.length})', style: TextStyles.captionMediumSemiBold),
              const Spacer(),
            ],
          ),
          if (presenters.isNotEmpty) ...[
            const SizedBox(height: 24),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final tastedRecordPresenter = presenters[index];
                return ChangeNotifierProvider.value(
                  value: tastedRecordPresenter,
                  child: ThrottleButton(
                    onTap: () {
                      showTastingRecordDetail(context: context, id: tastedRecordPresenter.id);
                    },
                    child: Container(color: ColorStyles.white, child: const TastedRecordInCoffeeBeanWidget()),
                  ),
                );
              },
              itemCount: presenters.length,
            ),
          ] else ...[
            const SizedBox(height: 46),
            Text('아직 작성된 시음기록이 없어요.', style: TextStyles.labelMediumMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(
              '버디님이 제일 먼저 시음 기록을 작성해보는 건 어때요?',
              style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
          ],
        ],
      ),
    );
  }

  Widget _buildMoreTastedRecordsButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 48.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          ThrottleButton(
            onTap: () {
              final name = context.read<CoffeeBeanDetailPresenter>().name;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TastedRecordInCoffeeBeanListScreen(name: name),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: ColorStyles.gray50),
                borderRadius: const BorderRadius.all(Radius.circular(8)),
              ),
              child: Center(child: Text('시음기록 더보기', style: TextStyles.labelMediumMedium)),
            ),
          ),
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
            child: Text('추천 원두', style: TextStyles.title02SemiBold),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            child: Row(
              spacing: 8,
              children: recommendedCoffeeBeans
                  .map((recommendedCoffeeBean) => _buildRecommendedCoffeeBean(recommendedCoffeeBean))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendedCoffeeBean(RecommendedCoffeeBean recommendedCoffeeBean) {
    return ThrottleButton(
      onTap: () {
        ScreenNavigator.showCoffeeBeanDetail(context: context, id: recommendedCoffeeBean.id);
      },
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

  Future<void> showEmptyDialog() {
    return showBarrierDialog(
      context: context,
      barrierColor: ColorStyles.black90,
      pageBuilder: (context, _, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 38),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    decoration: const BoxDecoration(
                      color: ColorStyles.white,
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '원두 정보가 없습니다.',
                          style: TextStyles.title02SemiBold,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text('비공식 원두는 상세페이지를 제공하지 않습니다.', style: TextStyles.bodyNarrowRegular),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.gray30,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '닫기',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.black),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ThrottleButton(
                                onTap: () {
                                  context.pop();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                                  decoration: const BoxDecoration(
                                    color: ColorStyles.black,
                                    borderRadius: BorderRadius.all(Radius.circular(8)),
                                  ),
                                  child: Text(
                                    '확인',
                                    textAlign: TextAlign.center,
                                    style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
