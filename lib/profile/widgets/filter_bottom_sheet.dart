import 'dart:math';

import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/viewport_offset.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

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
  bool _isAnimated = false;
  SfRangeValues values = const SfRangeValues(1, 5);

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    scrollController = ScrollController();
    scrollController.addListener(() {
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
    });
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
              child: Column(
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
                          _buildKindFilter(_tabKeys[0]),
                          Container(height: 8, color: ColorStyles.gray20),
                          _buildOriginFilter(_tabKeys[1]),
                          Container(height: 8, color: ColorStyles.gray20),
                          _buildRatingFilter(_tabKeys[2]),
                          Container(height: 8, color: ColorStyles.gray20),
                          _buildDecafFilter(_tabKeys[3]),
                          Container(height: 8, color: ColorStyles.gray20),
                          _buildRoastingPointFilter(_tabKeys[4]),
                        ],
                      ),
                    ),
                  ),
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
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKindFilter(GlobalKey key) {
    return Padding(
      key: _tabKeys[0],
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
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorStyles.red, width: 1)),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                      color: ColorStyles.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text('전체', style: TextStyles.labelMediumMedium),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorStyles.red, width: 1)),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                      color: ColorStyles.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text('싱글오리진', style: TextStyles.labelMediumMedium),
              const SizedBox(width: 80),
              Container(
                height: 20,
                width: 20,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: ColorStyles.red, width: 1)),
                child: Center(
                  child: Container(
                    height: 12,
                    width: 12,
                    decoration: const BoxDecoration(
                      color: ColorStyles.red,
                      shape: BoxShape.circle,
                    ),
                  ),
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

  Widget _buildOriginFilter(GlobalKey key) {
    final List<List<String>> origins = [
      [
        '과테말라',
        '니카라과',
        '멕시코',
        '볼리비아',
        '브라질',
        '에콰도르',
        '엘살바도르',
        '온두라스',
        '자메이카',
        '코스타리카',
        '콜롬비아',
        '파나마',
        '페루',
      ],
      [
        '르완다',
        '에티오피아',
        '케냐',
      ],
      [
        '수마트라',
        '예맨',
        '인도',
        '인도네시아',
        '파푸아뉴기니',
        '하와이',
      ],
    ];
    return Padding(
      key: _tabKeys[1],
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '중남미',
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 12),
              Column(
                children: List<Widget>.generate(
                  (origins[0].length / 5).ceil(),
                  (columnIndex) => Row(
                    children: List<Widget>.generate(
                      min(5, origins[0].length - (columnIndex * 5)),
                      (rowIndex) => InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                              color: ColorStyles.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorStyles.gray50,
                                width: 1,
                              )),
                          child: Text(
                            origins[0][columnIndex * 5 + rowIndex],
                            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ).separator(separatorWidget: SizedBox(width: 6)).toList(),
                  ),
                ).separator(separatorWidget: SizedBox(height: 8)).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                '아프리카',
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 12),
              Column(
                children: List<Widget>.generate(
                  (origins[1].length / 5).ceil(),
                  (columnIndex) => Row(
                    children: List<Widget>.generate(
                      min(5, origins[1].length - (columnIndex * 5)),
                      (rowIndex) => InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                              color: ColorStyles.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorStyles.gray50,
                                width: 1,
                              )),
                          child: Text(
                            origins[1][columnIndex * 5 + rowIndex],
                            style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ).separator(separatorWidget: SizedBox(width: 6)).toList(),
                  ),
                ).separator(separatorWidget: SizedBox(height: 8)).toList(),
              ),
              const SizedBox(height: 16),
              const Text(
                '기타',
                style: TextStyles.title01SemiBold,
              ),
              const SizedBox(height: 12),
              Column(
                children: List<Widget>.generate(
                  (origins[2].length / 5).ceil(),
                  (columnIndex) => Row(
                    children: List<Widget>.generate(
                      min(5, origins[2].length - (columnIndex * 5)),
                      (rowIndex) => InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                          decoration: BoxDecoration(
                              color: ColorStyles.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: ColorStyles.gray50,
                                width: 1,
                              )),
                          child: Text(
                            origins[2][columnIndex * 5 + rowIndex],
                            style: TextStyles.captionMediumRegular.copyWith(color: ColorStyles.gray50),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ).separator(separatorWidget: SizedBox(width: 6)).toList(),
                  ),
                ).separator(separatorWidget: SizedBox(height: 8)).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(GlobalKey key) {
    return Padding(
      key: _tabKeys[2],
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
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                const Text('0.5 ~ 5.0', style: TextStyles.title02Bold),
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
                    tickOffset: Offset(0, -6),
                    tickSize: Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: Offset(0, 8),
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
                    values: values,
                    onChanged: (newValues) {
                      setState(() {
                        values = newValues;
                      });
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

  Widget _buildDecafFilter(GlobalKey key) {
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
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              decoration: BoxDecoration(
                  color: ColorStyles.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: ColorStyles.gray50,
                    width: 1,
                  )),
              child: Text(
                '디카페인',
                style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray50),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoastingPointFilter(GlobalKey key) {
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
            margin: EdgeInsets.all(12),
            child: Column(
              children: [
                const Text('라이트 ~ 무거운', style: TextStyles.title02Bold),
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
                    tickOffset: Offset(0, -6),
                    tickSize: Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: Offset(0, 8),
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
                    values: values,
                    onChangeStart: (_) {
                      if(tabController.index != 4) {
                        tabController.animateTo(4);
                      }
                    },
                    onChanged: (newValues) {
                      setState(() {
                        values = newValues;
                      });
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
