import 'dart:math';

import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/icon_button_factory.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/profile/presenter/filter_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/viewport_offset.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:velocity_x/velocity_x.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> with SingleTickerProviderStateMixin {
  late final TabController tabController;
  late final ScrollController scrollController;
  final _scrollViewKey = GlobalKey();
  final _tabKeys = List<GlobalKey>.generate(5, (index) => GlobalKey());

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FilterPresenter>().init();
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    scrollController.dispose();
    scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    final RenderBox scrollViewBox = _scrollViewKey.currentContext?.findRenderObject() as RenderBox;
    final Offset scrollViewOffset = scrollViewBox.localToGlobal(Offset.zero);
    final currentIndex = tabController.index;
    switch (scrollController.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        if (currentIndex > 0) {
          final RenderBox viewBox = _tabKeys[currentIndex].currentContext?.findRenderObject() as RenderBox;
          Offset? offset = viewBox.localToGlobal(Offset.zero);
          if (offset.dy - scrollViewOffset.dy > 0) {
            tabController.animateTo(currentIndex - 1);
          }
        }
        break;
      case ScrollDirection.reverse:
        if (currentIndex < 4) {
          final RenderBox viewBox = _tabKeys[currentIndex + 1].currentContext?.findRenderObject() as RenderBox;
          Offset? offset = viewBox.localToGlobal(Offset.zero);
          if (offset.dy - scrollViewOffset.dy <= 0) {
            tabController.animateTo(currentIndex + 1);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: 564,
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Consumer<FilterPresenter>(builder: (context, presenter, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TabBar(
                      controller: tabController,
                      padding: const EdgeInsets.only(left: 16, right: 16, top: 24),
                      indicator: const UnderlineTabIndicator(
                        borderSide: BorderSide(color: ColorStyles.black, width: 2),
                        insets: EdgeInsets.only(top: 6),
                      ),
                      indicatorSize: TabBarIndicatorSize.label,
                      isScrollable: true,
                      tabAlignment: TabAlignment.center,
                      labelPadding: const EdgeInsets.only(top: 8, left: 8, right: 16),
                      labelStyle: TextStyles.title01SemiBold,
                      labelColor: ColorStyles.black,
                      unselectedLabelStyle: TextStyles.title01SemiBold,
                      unselectedLabelColor: ColorStyles.gray50,
                      dividerHeight: 0,
                      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                      tabs: [
                        const Tab(text: '원두유형', height: 31),
                        const Tab(text: '원산지', height: 31),
                        const Tab(text: '별점', height: 31),
                        const Tab(text: '디카페인', height: 31),
                        const Tab(text: '로스팅 포인트', height: 31),
                      ],
                      onTap: (index) {
                        Scrollable.ensureVisible(_tabKeys[index].currentContext!);
                      },
                    ),
                    Container(height: 2, color: ColorStyles.gray20),
                    Expanded(
                      child: SingleChildScrollView(
                        key: _scrollViewKey,
                        controller: scrollController,
                        child: Column(
                          children: [
                            _buildKindFilter(_tabKeys[0], presenter),
                            Container(height: 8, color: ColorStyles.gray20),
                            _buildOriginFilter(_tabKeys[1], presenter),
                            Container(height: 8, color: ColorStyles.gray20),
                            _buildRatingFilter(_tabKeys[2], presenter),
                            Container(height: 8, color: ColorStyles.gray20),
                            _buildDecafFilter(_tabKeys[3], presenter),
                            Container(height: 8, color: ColorStyles.gray20),
                            _buildRoastingPointFilter(_tabKeys[4], presenter),
                          ],
                        ),
                      ),
                    ),
                    presenter.filter.isNotEmpty
                        ? Container(
                            height: 56,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.all(16),
                              itemCount: presenter.filter.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    presenter.removeAtFilter(index);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: ColorStyles.background,
                                      border: Border.all(color: ColorStyles.red, width: 1),
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Row(
                                      children: [
                                        Text(
                                          presenter.filter[index].text,
                                          style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red),
                                        ),
                                        SizedBox(width: 2),
                                        SvgPicture.asset(
                                          'assets/icons/x.svg',
                                          width: 12,
                                          height: 12,
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) => SizedBox(width: 4),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 46, left: 16, right: 16),
                      child: Row(
                        children: [
                          ButtonFactory.buildRoundedButton(
                            onTapped: () {
                              context.pop();
                            },
                            text: '닫기',
                            style: RoundedButtonStyle.fill(
                              color: ColorStyles.gray30,
                              textColor: ColorStyles.black,
                              size: RoundedButtonSize.xSmall,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ButtonFactory.buildRoundedButton(
                            onTapped: () {},
                            text: '선택하기',
                            style: RoundedButtonStyle.fill(
                              color: ColorStyles.black,
                              textColor: ColorStyles.white,
                              size: RoundedButtonSize.large,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKindFilter(GlobalKey key, FilterPresenter presenter) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '원두유형',
            style: TextStyles.title02SemiBold,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              InkWell(
                onTap: () {
                  presenter.onChangeAllTypeState();
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: presenter.isAllSelectedType ? ColorStyles.red : ColorStyles.gray50,
                      width: 1,
                    ),
                  ),
                  child: presenter.isAllSelectedType
                      ? Center(
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              color: ColorStyles.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              const SizedBox(width: 12),
              const Text('전체', style: TextStyles.labelMediumMedium),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              InkWell(
                onTap: () {
                  presenter.onChangeSingleOriginState();
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: presenter.isSelectedSingleOrigin ? ColorStyles.red : ColorStyles.gray50,
                      width: 1,
                    ),
                  ),
                  child: presenter.isSelectedSingleOrigin
                      ? Center(
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              color: ColorStyles.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              const SizedBox(width: 12),
              const Text('싱글오리진', style: TextStyles.labelMediumMedium),
              const SizedBox(width: 80),
              InkWell(
                onTap: () {
                  presenter.onChangeBlendState();
                },
                child: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: presenter.isSelectedBlend ? ColorStyles.red : ColorStyles.gray50,
                      width: 1,
                    ),
                  ),
                  child: presenter.isSelectedBlend
                      ? Center(
                          child: Container(
                            height: 12,
                            width: 12,
                            decoration: const BoxDecoration(
                              color: ColorStyles.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
              const SizedBox(width: 12),
              const Text('블렌드', style: TextStyles.labelMediumMedium),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOriginFilter(GlobalKey key, FilterPresenter presenter) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '생산국가',
            style: TextStyles.title02Bold,
          ),
          const SizedBox(height: 20),
          Column(
            children: presenter.continent
                .map(
                  (continent) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        continent.toString(),
                        style: TextStyles.title01SemiBold,
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: List<Widget>.generate(
                          (continent.countries().length / 5).ceil(),
                          (columnIndex) => Row(
                            children: List<Widget>.generate(
                              min(5, continent.countries().length - (columnIndex * 5)),
                              (rowIndex) => InkWell(
                                onTap: () {
                                  presenter.onChangeStateOrigin(continent.countries()[columnIndex * 5 + rowIndex]);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                  decoration: BoxDecoration(
                                      color:
                                          presenter.isSelectedOrigin(continent.countries()[columnIndex * 5 + rowIndex])
                                              ? ColorStyles.background
                                              : ColorStyles.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: presenter
                                                .isSelectedOrigin(continent.countries()[columnIndex * 5 + rowIndex])
                                            ? ColorStyles.red
                                            : ColorStyles.gray50,
                                        width: 1,
                                      )),
                                  child: Text(
                                    continent.countries()[columnIndex * 5 + rowIndex].toString(),
                                    style: TextStyles.captionMediumMedium.copyWith(
                                      color:
                                          presenter.isSelectedOrigin(continent.countries()[columnIndex * 5 + rowIndex])
                                              ? ColorStyles.red
                                              : ColorStyles.black,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ).separator(separatorWidget: const SizedBox(width: 6)).toList(),
                          ),
                        ).separator(separatorWidget: const SizedBox(height: 8)).toList(),
                      )
                    ],
                  ),
                )
                .separator(separatorWidget: const SizedBox(height: 16))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(GlobalKey key, FilterPresenter presenter) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '별점',
            style: TextStyles.title02SemiBold,
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(presenter.ratingString, style: TextStyles.title02Bold),
                const SizedBox(height: 36),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                    trackCornerRadius: 0,
                    activeTrackHeight: 2,
                    inactiveTrackHeight: 2,
                    activeTrackColor: ColorStyles.red,
                    inactiveTrackColor: ColorStyles.gray40,
                    thumbColor: ColorStyles.white,
                    thumbStrokeColor: ColorStyles.gray50,
                    thumbStrokeWidth: 2,
                    thumbRadius: 10,
                    tickOffset: const Offset(0, -6),
                    tickSize: const Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: const Offset(0, 8),
                    activeLabelStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60),
                    inactiveLabelStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60),
                  ),
                  child: SfRangeSlider(
                    min: 0.5,
                    max: 5,
                    showTicks: true,
                    interval: 0.5,
                    stepSize: 0.5,
                    showLabels: true,
                    labelFormatterCallback: (dynamic actualValue, String formattedText) {
                      return actualValue == 0.5 || actualValue == 5.0 ? '$actualValue' : '';
                    },
                    values: presenter.ratingValues,
                    onChanged: (newValues) {
                      presenter.onChangeRatingValues(values: newValues);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDecafFilter(GlobalKey key, FilterPresenter presenter) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '디카페인 여부',
            style: TextStyles.title02SemiBold,
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () {
              presenter.onChangeIsDecaf();
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  color: presenter.isDecaf ? ColorStyles.background : ColorStyles.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: presenter.isDecaf ? ColorStyles.red : ColorStyles.gray50,
                    width: 1,
                  )),
              child: Text(
                '디카페인',
                style: TextStyles.captionMediumMedium.copyWith(
                  color: presenter.isDecaf ? ColorStyles.red : ColorStyles.black,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoastingPointFilter(GlobalKey key, FilterPresenter presenter) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '로스팅 포인트',
            style: TextStyles.title02Bold,
          ),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(presenter.roastingPointString, style: TextStyles.title02Bold),
                const SizedBox(height: 36),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                    trackCornerRadius: 0,
                    activeTrackHeight: 2,
                    inactiveTrackHeight: 2,
                    activeTrackColor: ColorStyles.red,
                    inactiveTrackColor: ColorStyles.gray40,
                    thumbColor: ColorStyles.white,
                    thumbStrokeColor: ColorStyles.gray50,
                    thumbStrokeWidth: 2,
                    thumbRadius: 10,
                    tickOffset: const Offset(0, -6),
                    tickSize: const Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: const Offset(0, 8),
                    activeLabelStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60),
                    inactiveLabelStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.gray60),
                  ),
                  child: SfRangeSlider(
                    min: 1,
                    max: 5,
                    showTicks: true,
                    interval: 1,
                    stepSize: 1,
                    showLabels: true,
                    values: presenter.roastingPointValues,
                    labelFormatterCallback: (dynamic num, String label) {
                      return presenter.toRoastingPointString(num);
                    },
                    onChangeStart: (_) {
                      if (tabController.index != 4) {
                        tabController.animateTo(4);
                      }
                    },
                    onChanged: (newValues) {
                      presenter.onChangeRoastingPointValues(values: newValues);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
