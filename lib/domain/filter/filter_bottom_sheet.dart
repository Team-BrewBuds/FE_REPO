import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/cancel_and_confirm_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/filter/filter_presenter.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/coffee_bean/country.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterBottomSheet extends StatefulWidget {
  final int initialTab;
  final Function(List<CoffeeBeanFilter> filters) onDone;

  const FilterBottomSheet({
    super.key,
    this.initialTab = 0,
    required this.onDone,
  });

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
    tabController = TabController(length: 5, vsync: this, initialIndex: widget.initialTab);
    scrollController = ScrollController();
    scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<FilterPresenter>().init();
      Scrollable.ensureVisible(_tabKeys[widget.initialTab].currentContext!);
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
              height: MediaQuery.of(context).size.height - 135,
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: SafeArea(
                top: false,
                child: Column(
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
                      overlayColor: const WidgetStatePropertyAll(Colors.transparent),
                      tabs: const [
                        Tab(text: '원두유형', height: 31),
                        Tab(text: '원산지', height: 31),
                        Tab(text: '별점', height: 31),
                        Tab(text: '디카페인', height: 31),
                        Tab(text: '로스팅 포인트', height: 31),
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
                    Selector<FilterPresenter, List<CoffeeBeanFilter>>(
                      selector: (context, presenter) => presenter.filter,
                      builder: (context, filterList, child) {
                        return filterList.isNotEmpty
                            ? Container(
                                color: ColorStyles.gray20,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  padding: const EdgeInsets.all(16),
                                  child: Row(
                                    spacing: 4,
                                    children: List.generate(
                                      filterList.length,
                                      (index) {
                                        final filter = filterList[index];
                                        return ThrottleButton(
                                          onTap: () {
                                            context.read<FilterPresenter>().removeAtFilter(index);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: ColorStyles.background,
                                              border: Border.all(color: ColorStyles.red, width: 1),
                                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              spacing: 2,
                                              children: [
                                                Text(
                                                  filter.text,
                                                  style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.red),
                                                ),
                                                SvgPicture.asset(
                                                  'assets/icons/x.svg',
                                                  width: 12,
                                                  height: 12,
                                                  fit: BoxFit.cover,
                                                  colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox.shrink();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 24, left: 16, right: 16),
                      child: CancelAndConfirmButton(
                        onCancel: () {
                          context.pop();
                        },
                        onConfirm: () {
                          widget.onDone.call(context.read<FilterPresenter>().filter);
                          context.pop();
                        },
                        cancelButtonChild: Text(
                          '닫기',
                          style: TextStyles.labelMediumMedium,
                          textAlign: TextAlign.center,
                        ),
                        confirmText: '선택하기',
                        isValid: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKindFilter(GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20,
        children: [
          Text(
            '원두유형',
            style: TextStyles.title02SemiBold,
          ),
          Row(
            children: [
              ThrottleButton(
                onTap: () {
                  context.read<FilterPresenter>().onChangeBeanType(CoffeeBeanType.singleOrigin);
                },
                child: SvgPicture.asset(
                  context.select<FilterPresenter, bool>((presenter) => presenter.isSelectedSingleOrigin)
                      ? 'assets/icons/checked.svg'
                      : 'assets/icons/uncheck.svg',
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('싱글오리진', style: TextStyles.labelMediumMedium),
              const SizedBox(width: 80),
              ThrottleButton(
                onTap: () {
                  context.read<FilterPresenter>().onChangeBeanType(CoffeeBeanType.blend);
                },
                child: SvgPicture.asset(
                  context.select<FilterPresenter, bool>((presenter) => presenter.isSelectedBlend)
                      ? 'assets/icons/checked.svg'
                      : 'assets/icons/uncheck.svg',
                  height: 20,
                  width: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text('블렌드', style: TextStyles.labelMediumMedium),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildOriginFilter(GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '원산지',
            style: TextStyles.title02Bold,
          ),
          Builder(builder: (context) {
            return Column(
              spacing: 16,
              children: Continent.values
                  .map(
                    (continent) => Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      spacing: 12,
                      children: [
                        Text(
                          continent.toString(),
                          style: TextStyles.title01SemiBold,
                        ),
                        Wrap(
                          direction: Axis.horizontal,
                          alignment: WrapAlignment.start,
                          spacing: 6,
                          runSpacing: 8,
                          children: continent
                              .countries()
                              .map<Widget>(
                                (country) => ThrottleButton(
                                  onTap: () {
                                    context.read<FilterPresenter>().onChangeStateOrigin(country);
                                  },
                                  child: Builder(builder: (context) {
                                    final isSelect = context.select<FilterPresenter, bool>(
                                      (presenter) => presenter.isSelectedOrigin(country),
                                    );
                                    return Container(
                                      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                                      decoration: BoxDecoration(
                                          color: isSelect ? ColorStyles.background : ColorStyles.white,
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                            color: isSelect ? ColorStyles.red : ColorStyles.gray50,
                                            width: 1,
                                          )),
                                      child: Text(
                                        country.toString(),
                                        style: TextStyles.captionMediumMedium.copyWith(
                                          color: isSelect ? ColorStyles.red : ColorStyles.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    );
                                  }),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRatingFilter(GlobalKey key) {
    return Padding(
      key: key,
      padding: const EdgeInsets.only(top: 24, bottom: 32, left: 16, right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '별점',
            style: TextStyles.title02SemiBold,
          ),
          const SizedBox(height: 8),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  context.select<FilterPresenter, String>((presenter) => presenter.ratingString),
                  style: TextStyles.title02Bold,
                ),
                const SizedBox(height: 36),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                    trackCornerRadius: 0,
                    activeTrackHeight: 2,
                    inactiveTrackHeight: 2,
                    activeTrackColor: ColorStyles.red,
                    inactiveTrackColor: ColorStyles.gray40,
                    tickOffset: const Offset(0, -6),
                    tickSize: const Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: const Offset(0, 14),
                    activeLabelStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.black),
                    inactiveLabelStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.black),
                  ),
                  child: SfRangeSlider(
                    min: 0.5,
                    max: 5,
                    showTicks: true,
                    interval: 0.5,
                    stepSize: 0.5,
                    showLabels: true,
                    thumbShape: const CircleThumbShape(),
                    labelFormatterCallback: (dynamic actualValue, String formattedText) {
                      return actualValue == 0.5 || actualValue == 5.0 ? '$actualValue' : '';
                    },
                    values: context.select<FilterPresenter, SfRangeValues>((presenter) => presenter.ratingValues),
                    onChanged: (newValues) {
                      context.read<FilterPresenter>().onChangeRatingValues(values: newValues);
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
        spacing: 16,
        children: [
          Text(
            '디카페인 여부',
            style: TextStyles.title02SemiBold,
          ),
          ThrottleButton(
            onTap: () {
              context.read<FilterPresenter>().onChangeIsDecaf();
            },
            child: Builder(builder: (context) {
              final isDecaf = context.select<FilterPresenter, bool>((presenter) => presenter.isDecaf);
              return Container(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                decoration: BoxDecoration(
                  color: isDecaf ? ColorStyles.background : ColorStyles.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDecaf ? ColorStyles.red : ColorStyles.gray50,
                    width: 1,
                  ),
                ),
                child: Text(
                  '디카페인',
                  style: TextStyles.captionMediumMedium.copyWith(color: isDecaf ? ColorStyles.red : ColorStyles.black),
                  textAlign: TextAlign.center,
                ),
              );
            }),
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
          Text(
            '로스팅 포인트',
            style: TextStyles.title02Bold,
          ),
          const SizedBox(height: 32),
          Container(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  context.select<FilterPresenter, String>((presenter) => presenter.roastingPointString),
                  style: TextStyles.title02Bold,
                ),
                const SizedBox(height: 36),
                SfRangeSliderTheme(
                  data: SfRangeSliderThemeData(
                    trackCornerRadius: 0,
                    activeTrackHeight: 2,
                    inactiveTrackHeight: 2,
                    activeTrackColor: ColorStyles.red,
                    inactiveTrackColor: ColorStyles.gray40,
                    tickOffset: const Offset(0, -6),
                    tickSize: const Size(1, 10),
                    activeTickColor: ColorStyles.red,
                    inactiveTickColor: ColorStyles.gray40,
                    labelOffset: const Offset(0, 14),
                    activeLabelStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray60),
                    inactiveLabelStyle: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray60),
                  ),
                  child: SfRangeSlider(
                    min: 1,
                    max: 5,
                    showTicks: true,
                    interval: 1,
                    stepSize: 1,
                    showLabels: true,
                    values:
                        context.select<FilterPresenter, SfRangeValues>((presenter) => presenter.roastingPointValues),
                    thumbShape: const CircleThumbShape(),
                    labelFormatterCallback: (dynamic num, String label) {
                      return context.read<FilterPresenter>().toRoastingPointString(num);
                    },
                    onChangeStart: (_) {
                      if (tabController.index != 4) {
                        tabController.animateTo(4);
                      }
                    },
                    onChanged: (newValues) {
                      context.read<FilterPresenter>().onChangeRoastingPointValues(values: newValues);
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

class CircleThumbShape extends SfThumbShape {
  const CircleThumbShape();

  @override
  Size getPreferredSize(SfSliderThemeData themeData) {
    return const Size.fromRadius(10);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required RenderBox parentBox,
    required RenderBox? child,
    required SfSliderThemeData themeData,
    SfRangeValues? currentValues,
    currentValue,
    required Paint? paint,
    required Animation<double> enableAnimation,
    required TextDirection textDirection,
    required SfThumb? thumb,
  }) {
    final Canvas canvas = context.canvas;

    final Paint fillPaint = Paint()
      ..color = ColorStyles.white
      ..style = PaintingStyle.fill;

    final Paint borderPaint = Paint()
      ..color = ColorStyles.gray50
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas
      ..drawCircle(center, 10, fillPaint)
      ..drawCircle(center, 10, borderPaint);
  }
}
