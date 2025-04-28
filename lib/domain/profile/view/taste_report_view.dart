import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/profile/presenter/tasted_report_presenter.dart';
import 'package:brew_buds/domain/profile/widgets/activity_calendar_builder.dart';
import 'package:brew_buds/domain/profile/widgets/profile_post_item_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_coffee_bean_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_tasting_record_widget.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/taste_report/activity_item.dart';
import 'package:brew_buds/model/taste_report/rating_distribution.dart';
import 'package:brew_buds/model/taste_report/top_country.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class TasteReportView extends StatefulWidget {
  const TasteReportView({super.key});

  @override
  State<TasteReportView> createState() => _TasteReportViewState();
}

class _TasteReportViewState extends State<TasteReportView> with SingleTickerProviderStateMixin {
  final Map<int, Color> colorMap = {
    1: ColorStyles.red,
    2: ColorStyles.gray40,
    3: ColorStyles.gray30,
    4: ColorStyles.gray20,
    5: ColorStyles.gray10,
  };
  final GlobalKey _scrollViewKey = GlobalKey();
  final List<GlobalKey> _keyList = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  bool _isExpanded = false;
  late final TabController _tabController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<TasteReportPresenter>().initState();
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  _scrollListener() {
    final RenderBox scrollViewBox = _scrollViewKey.currentContext?.findRenderObject() as RenderBox;
    final Offset scrollViewOffset = scrollViewBox.localToGlobal(Offset.zero);
    final currentIndex = _tabController.index;
    switch (_scrollController.position.userScrollDirection) {
      case ScrollDirection.idle:
        break;
      case ScrollDirection.forward:
        if (currentIndex > 0) {
          final RenderBox viewBox = _keyList[currentIndex].currentContext?.findRenderObject() as RenderBox;
          Offset? offset = viewBox.localToGlobal(Offset.zero);
          if (offset.dy - scrollViewOffset.dy > 0) {
            _tabController.animateTo(currentIndex - 1);
          }
        }
        break;
      case ScrollDirection.reverse:
        if (currentIndex < 3) {
          final RenderBox viewBox = _keyList[currentIndex + 1].currentContext?.findRenderObject() as RenderBox;
          Offset? offset = viewBox.localToGlobal(Offset.zero);
          if (offset.dy - scrollViewOffset.dy <= 0) {
            _tabController.animateTo(currentIndex + 1);
          }
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: _buildAppBar(),
          body: SafeArea(
            child: CustomScrollView(
              key: _scrollViewKey,
              controller: _scrollController,
              slivers: [
                SliverToBoxAdapter(
                  child: ExtendedImage.asset(
                    'assets/images/owner.png',
                    height: 150,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Selector<TasteReportPresenter, ActivityInformationState>(
                    selector: (context, presenter) => presenter.activityInformationState,
                    builder: (context, activityInformationState, child) => _buildActivityInformation(
                      tastingRecordCount: activityInformationState.tastingReportCount,
                      postCount: activityInformationState.postCount,
                      savedNoteCount: activityInformationState.savedNoteCount,
                      savedBeanCount: activityInformationState.savedBeanCount,
                    ),
                  ),
                ),
                _buildTabBar(),
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
                _buildActivityCalendar(),
                const SliverToBoxAdapter(child: SizedBox(height: 32)),
                _buildActivityList(),
                SliverToBoxAdapter(child: Container(height: 8, color: ColorStyles.gray20)),
                Selector<TasteReportPresenter, RatingDistribution?>(
                  selector: (context, presenter) => presenter.ratingDistribution,
                  builder: (context, ratingDistribution, child) =>
                      _buildRatingGraph(ratingDistribution: ratingDistribution),
                ),
                SliverToBoxAdapter(child: Container(height: 8, color: ColorStyles.gray20)),
                Selector<TasteReportPresenter, List<TopFlavor>>(
                  selector: (context, presenter) => presenter.topFlavor,
                  builder: (context, topFlavors, child) => _buildFlavor(topFlavors: topFlavors),
                ),
                SliverToBoxAdapter(child: Container(height: 8, color: ColorStyles.gray20)),
                Selector<TasteReportPresenter, List<TopCountry>>(
                  selector: (context, presenter) => presenter.topCountry,
                  builder: (context, topCountry, child) => _buildCountry(topCountryList: topCountry),
                ),
              ],
            ),
          ),
        ),
        if (context.select<TasteReportPresenter, bool>(
          (presenter) => presenter.isLoading,
        ))
          const Positioned.fill(child: LoadingBarrier()),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      centerTitle: false,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ThrottleButton(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                fit: BoxFit.cover,
                height: 24,
                width: 24,
              ),
            ),
            const Spacer(),
            Selector<TasteReportPresenter, String>(
                selector: (context, presenter) => presenter.nickname,
                builder: (context, nickname, child) => Text(nickname, style: TextStyles.title02Bold)),
            const Spacer(),
            const SizedBox(
              height: 24,
              width: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityInformation({
    required int tastingRecordCount,
    required int postCount,
    required int savedNoteCount,
    required int savedBeanCount,
  }) {
    String countToString(int num) {
      if (num >= 1000000) {
        return '${(num / 1000000).toStringAsFixed(1)}M';
      } else if (num >= 1000) {
        return '${(num / 1000).toStringAsFixed(1)}K';
      } else {
        return num.toString();
      }
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 12, left: 16, right: 16),
            child: Row(
              children: [
                Text('활동 요약', style: TextStyles.title02Bold),
                const Spacer(),
                Row(
                  children: [
                    SvgPicture.asset(
                      height: 14,
                      width: 14,
                      'assets/icons/information.svg',
                      colorFilter: const ColorFilter.mode(ColorStyles.gray50, BlendMode.srcIn),
                    ),
                    Text(
                      '최근 1개월간 브루버즈에서의 활동을 요약했어요.',
                      style: TextStyles.captionSmallRegular.copyWith(color: ColorStyles.gray50),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 32, right: 32, top: 13.5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text(countToString(tastingRecordCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    Text('시음기록', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(postCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    Text('게시글', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(savedNoteCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    Text('저장한 노트', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(savedBeanCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    Text('찜한 원두', style: TextStyles.captionMediumMedium)
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return SliverAppBar(
      leadingWidth: 0,
      leading: const SizedBox.shrink(),
      titleSpacing: 0,
      floating: true,
      toolbarHeight: 65,
      title: TabBar(
        controller: _tabController,
        padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
        indicatorPadding: const EdgeInsets.only(top: 4),
        indicatorSize: TabBarIndicatorSize.label,
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide(width: 2, color: ColorStyles.black),
        ),
        labelPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        tabAlignment: TabAlignment.start,
        isScrollable: true,
        labelStyle: TextStyles.title01SemiBold,
        labelColor: ColorStyles.black,
        unselectedLabelStyle: TextStyles.title01SemiBold,
        unselectedLabelColor: ColorStyles.gray50,
        dividerHeight: 1,
        dividerColor: ColorStyles.gray20,
        overlayColor: const WidgetStatePropertyAll(Colors.transparent),
        tabs: const [
          Tab(text: '활동 캘린더', height: 31),
          Tab(text: '별점 분포', height: 31),
          Tab(text: '선호 맛', height: 31),
          Tab(text: '선호 원산지', height: 31),
        ],
        onTap: (index) {
          final tapContext = _keyList[index].currentContext;
          if (tapContext != null) {
            Scrollable.ensureVisible(tapContext,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                alignment: 0,
                alignmentPolicy: ScrollPositionAlignmentPolicy.explicit);
          }
        },
      ),
    );
  }

  Widget _buildActivityCalendar() {
    return SliverToBoxAdapter(
      child: Container(
        key: _keyList[0],
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            Row(
              children: [
                Text('활동 캘린더', style: TextStyles.title02Bold),
                const Spacer(),
                Selector<TasteReportPresenter, ActivityTypeState>(
                  selector: (context, presenter) => presenter.activityTypeState,
                  builder: (context, activityTypeState, child) => ThrottleButton(
                    onTap: () {
                      showActivityBottomSheet(
                        activityTypeList: activityTypeState.activityTypeList,
                        currentActivityType: activityTypeState.currentActivityType,
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.only(top: 4, left: 8, right: 4, bottom: 4),
                      decoration: BoxDecoration(
                        color: ColorStyles.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          Text(
                            activityTypeState.currentActivityType,
                            style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                          ),
                          SvgPicture.asset(
                            'assets/icons/down.svg',
                            height: 18,
                            width: 17,
                            colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildCalendar(),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendar() {
    final daysOfWeekTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.sp,
      height: 16.8 / 14,
      letterSpacing: -0.01,
    );
    return Selector<TasteReportPresenter, ActivityCalendarState>(
      selector: (context, presenter) => presenter.activityCalendarState,
      builder: (context, state, child) => Column(
        children: [
          Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text('오늘', style: TextStyles.labelSmallMedium.copyWith(color: Colors.transparent)),
                ),
                Row(
                  children: [
                    ThrottleButton(
                      onTap: () {
                        context.read<TasteReportPresenter>().movePreviousMonth();
                      },
                      child: SvgPicture.asset('assets/icons/back.svg', height: 24, width: 24),
                    ),
                    const SizedBox(width: 20),
                    Text('${state.focusedDay.year}년 ${state.focusedDay.month}월', style: TextStyles.title01SemiBold),
                    const SizedBox(width: 20),
                    ThrottleButton(
                      onTap: () {
                        context.read<TasteReportPresenter>().moveNextMonth();
                      },
                      child: SvgPicture.asset('assets/icons/arrow.svg', height: 24, width: 24),
                    ),
                  ],
                ),
                ThrottleButton(
                  onTap: () {
                    context.read<TasteReportPresenter>().goToday();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    child: Text('오늘', style: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.red)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          TableCalendar(
            locale: 'ko_KR',
            focusedDay: state.focusedDay,
            selectedDayPredicate: (day) => isSameDay(state.selectedDay, day),
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime(1970, 1, 1),
            lastDay: DateTime(2099, 12, 31),
            headerVisible: false,
            daysOfWeekHeight: 44,
            rowHeight: 50,
            availableGestures: AvailableGestures.horizontalSwipe,
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: daysOfWeekTextStyle,
              weekdayStyle: daysOfWeekTextStyle,
            ),
            calendarStyle: const CalendarStyle(isTodayHighlighted: false, outsideDaysVisible: false),
            calendarBuilders: ActivityCalendarBuilder(fetchActivityCount: (DateTime day) {
              return state.activityCount[day.toDefaultString()] ?? 0;
            }),
            onDaySelected: (day, _) {
              context.read<TasteReportPresenter>().onSelectedDay(day);
            },
            onPageChanged: (day) {
              context.read<TasteReportPresenter>().onPageChange(day);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityList() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorStyles.gray20)),
        ),
        child: Selector<TasteReportPresenter, ActivityListState>(
          selector: (context, presenter) => presenter.activityListState,
          builder: (context, activityListState, child) {
            return Column(
              children: [
                ThrottleButton(
                  onTap: () {
                    _toggleExpanded();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          '${activityListState.currentActivityType} (${activityListState.items.length})',
                          style: TextStyles.title02Bold,
                        ),
                        const Spacer(),
                        if (_isExpanded)
                          SvgPicture.asset('assets/icons/up.svg', width: 24, height: 24)
                        else
                          SvgPicture.asset('assets/icons/down.svg', width: 24, height: 24)
                      ],
                    ),
                  ),
                ),
                if (_isExpanded)
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: activityListState.items.length,
                    itemBuilder: (context, index) {
                      final activity = activityListState.items[index];
                      switch (activity) {
                        case PostActivityItem():
                          return ThrottleButton(
                            onTap: () {
                              ScreenNavigator.showTastedRecordDetail(context: context, id: activity.id);
                            },
                            child: ProfilePostItemWidget(
                              title: activity.title,
                              author: activity.author,
                              createdAt: activity.createdAt,
                              subject: activity.subject,
                            ),
                          );
                        case TastedRecordActivityItem():
                          return ThrottleButton(
                            onTap: () {
                              ScreenNavigator.showTastedRecordDetail(context: context, id: activity.id);
                            },
                            child: SavedTastingRecordWidget(
                              beanName: activity.beanName,
                              rating: '${activity.rating}',
                              flavor: activity.flavors,
                              imageUri: activity.thumbnail,
                            ),
                          );
                        case SavedBeanActivityItem():
                          return SavedCoffeeBeanWidget(
                            name: activity.name,
                            rating: '${activity.rating}',
                            tastedRecordsCount: 0,
                            imageUri: '',
                          );
                      }
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: ColorStyles.gray30,
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }

  _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  Widget _buildRatingGraph({required RatingDistribution? ratingDistribution}) {
    List<String> ratingKey = ['0.0', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0', '3.5', '4.0', '4.5', '5.0', '5.5'];

    return SliverToBoxAdapter(
      child: Column(
        key: _keyList[1],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            child: Text('별점 분포', style: TextStyles.title02Bold),
          ),
          const SizedBox(height: 24),
          if (ratingDistribution != null && ratingDistribution.ratingCount != 0) ...[
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: BarChart(
                BarChartData(
                  barGroups: List<BarChartGroupData>.generate(ratingKey.length, (index) {
                    final rating = ratingKey[index];
                    final topIndex = ratingKey.indexOf('${ratingDistribution.mostRating}');
                    final count = ratingDistribution.ratingDistribution[rating] ?? 0;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: index == 0 || index == 11 ? 0.0 : (count / ratingDistribution.ratingCount) + 0.01,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                          color: topIndex == index ? ColorStyles.red : ColorStyles.gray20,
                          width: 24,
                        ),
                      ],
                      showingTooltipIndicators: (index == 1 || index == 10) || topIndex == index ? [0] : null,
                    );
                  }),
                  groupsSpace: 3,
                  titlesData: const FlTitlesData(show: false),
                  barTouchData: BarTouchData(
                    enabled: false,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.transparent,
                      tooltipPadding: EdgeInsets.zero,
                      tooltipMargin: 2,
                      getTooltipItem: (
                        BarChartGroupData group,
                        int groupIndex,
                        BarChartRodData rod,
                        int rodIndex,
                      ) {
                        return BarTooltipItem(
                          ratingKey[groupIndex],
                          TextStyles.labelSmallSemiBold.copyWith(
                            color: '${ratingDistribution.mostRating}' == ratingKey[groupIndex]
                                ? ColorStyles.red
                                : ColorStyles.gray50,
                          ),
                        );
                      },
                    ),
                  ),
                  borderData:
                      FlBorderData(border: const Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1))),
                  gridData: const FlGridData(show: false),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 1,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              height: 73,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ratingDistribution.avgRating.toStringAsFixed(1),
                        style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red),
                      ),
                      const SizedBox(height: 6),
                      Text('별점 평균', style: TextStyles.captionMediumMedium),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${ratingDistribution.ratingCount}',
                        style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red),
                      ),
                      const SizedBox(height: 6),
                      Text('별점 개수', style: TextStyles.captionMediumMedium),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        ratingDistribution.mostRating.toStringAsFixed(1),
                        style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red),
                      ),
                      const SizedBox(height: 6),
                      Text('주요 별점', style: TextStyles.captionMediumMedium),
                    ],
                  ),
                ],
              ),
            ),
          ] else ...[
            _buildEmpty(),
          ],
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildFlavor({required List<TopFlavor> topFlavors}) {
    return SliverToBoxAdapter(
      child: Padding(
        key: _keyList[2],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text('선호하는 맛', style: TextStyles.title02Bold),
            ),
            if (topFlavors.isEmpty)
              _buildEmpty()
            else
              Container(
                margin: const EdgeInsets.only(top: 16, right: 36, left: 36, bottom: 16),
                height: 200,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          startDegreeOffset: -90,
                          sections: List<PieChartSectionData>.generate(
                            topFlavors.length,
                            (index) {
                              final topFlavor = topFlavors[index];
                              return _buildSectionData(percent: topFlavor.percent, rank: index + 1);
                            },
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 70,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '1',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32.sp,
                                  height: 38.4 / 32,
                                  letterSpacing: -0.01,
                                  color: ColorStyles.red,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('위', style: TextStyles.title02Bold.copyWith(color: ColorStyles.red)),
                            ],
                          ),
                          Text(topFlavors.first.flavor, style: TextStyles.title02Bold),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                spacing: 16,
                children: List.generate(
                  topFlavors.length,
                  (index) => _buildRankRow(
                    rank: index + 1,
                    title: topFlavors[index].flavor,
                    percent: topFlavors[index].percent,
                  ),
                ).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: ColorStyles.gray10,
                child: Text(
                  '선호하는 맛은 회원님이 3.5점 이상으로 평가한 원두의 맛에, 별점에 따른 가중치를 부여한 뒤 가중 평균을 계산하여 그 결과를 바탕으로 최소 1개, 최대 5개의 맛까지 순위대로 나타냅니다.',
                  maxLines: null,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 16.8 / 12,
                      letterSpacing: -0.01,
                      color: ColorStyles.gray50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountry({required List<TopCountry> topCountryList}) {
    return SliverToBoxAdapter(
      child: Padding(
        key: _keyList[3],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 16),
              child: Text('선호하는 원산지', style: TextStyles.title02Bold),
            ),
            if (topCountryList.isEmpty)
              _buildEmpty()
            else
              Container(
                margin: const EdgeInsets.only(top: 16, right: 36, left: 36, bottom: 16),
                height: 200,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: PieChart(
                        PieChartData(
                          borderData: FlBorderData(show: false),
                          startDegreeOffset: -90,
                          sections: List<PieChartSectionData>.generate(
                            topCountryList.length,
                            (index) {
                              final topCountry = topCountryList[index];
                              return _buildSectionData(percent: topCountry.percent, rank: index + 1);
                            },
                          ),
                          sectionsSpace: 0,
                          centerSpaceRadius: 70,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '1',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 32.sp,
                                  height: 38.4 / 32,
                                  letterSpacing: -0.01,
                                  color: ColorStyles.red,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text('위', style: TextStyles.title02Bold.copyWith(color: ColorStyles.red)),
                            ],
                          ),
                          Text(topCountryList.first.country, style: TextStyles.title02Bold),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                spacing: 16,
                children: List.generate(
                  topCountryList.length,
                  (index) => _buildRankRow(
                    rank: index + 1,
                    title: topCountryList[index].country,
                    percent: topCountryList[index].percent,
                  ),
                ).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: ColorStyles.gray10,
                child: Text(
                  '선호하는 맛은 회원님이 3.5점 이상으로 평가한 원두의 맛에, 별점에 따른 가중치를 부여한 뒤 가중 평균을 계산하여 그 결과를 바탕으로 최소 1개, 최대 5개의 맛까지 순위대로 나타냅니다.',
                  maxLines: null,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12.sp,
                      height: 16.8 / 12,
                      letterSpacing: -0.01,
                      color: ColorStyles.gray50),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  PieChartSectionData _buildSectionData({required double percent, required int rank}) {
    return PieChartSectionData(
      radius: 30,
      value: percent,
      color: colorMap[rank] ?? ColorStyles.black,
      showTitle: false,
    );
  }

  Widget _buildRankRow({required int rank, required String title, required double percent}) {
    return Row(
      children: [
        Container(
          height: 22,
          width: 22,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: colorMap[rank] ?? ColorStyles.black,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecoration(
            border: Border.all(color: rank == 1 ? ColorStyles.red : ColorStyles.gray60),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            title,
            style: TextStyles.captionMediumMedium.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray60),
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Text(
            '${percent.toStringAsFixed(2)}%',
            style: TextStyles.title01SemiBold.copyWith(color: rank == 1 ? ColorStyles.red : ColorStyles.gray60),
          ),
        )
      ],
    );
  }

  Widget _buildEmpty() {
    return Column(
      children: [
        Text('아직 작성한 시음기록이 없어요.', style: TextStyles.title02SemiBold),
        const SizedBox(height: 8),
        Text(
          '시음 기록 1개 작성하고 내 커피 취향을 알아보는 건 어때요?',
          style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.gray50),
        ),
        const SizedBox(height: 24),
        Container(height: 160, width: 160, color: const Color(0xffd9d9d9)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          decoration: const BoxDecoration(color: ColorStyles.red, borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Text(
            '시음기록 작성하기',
            style: TextStyles.captionMediumSemiBold.copyWith(color: ColorStyles.white),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  showActivityBottomSheet({required List<String> activityTypeList, required String currentActivityType}) async {
    final result = await showBarrierDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
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
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 8,
                        children: [
                          Container(
                            padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: ColorStyles.gray20, width: 1),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                ),
                                const Spacer(),
                                Text('활동 보기', style: TextStyles.title02SemiBold),
                                const Spacer(),
                                ThrottleButton(
                                  onTap: () {
                                    context.pop();
                                  },
                                  child: SvgPicture.asset(
                                    'assets/icons/x.svg',
                                    height: 24,
                                    width: 24,
                                    fit: BoxFit.cover,
                                    colorFilter: const ColorFilter.mode(ColorStyles.black, BlendMode.srcIn),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ...List.generate(
                            activityTypeList.length,
                            (index) {
                              final type = activityTypeList[index];
                              return ThrottleButton(
                                onTap: () => context.pop(index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                                  child: type == currentActivityType
                                      ? Row(
                                          children: [
                                            Text(type,
                                                style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.red)),
                                            const Spacer(),
                                            const Icon(
                                              Icons.check,
                                              color: ColorStyles.red,
                                              size: 14,
                                            ),
                                          ],
                                        )
                                      : Text(type, style: TextStyles.labelMediumMedium),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
    //수정필요
    if (result != null && context.mounted) {
      context.read<TasteReportPresenter>().onChangeActivityType(result as int);
    }
  }
}
