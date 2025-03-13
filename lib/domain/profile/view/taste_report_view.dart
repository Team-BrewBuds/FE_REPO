import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/domain/detail/show_detail.dart';
import 'package:brew_buds/domain/profile/model/in_profile/bean_in_profile.dart';
import 'package:brew_buds/domain/profile/model/in_profile/post_in_profile.dart';
import 'package:brew_buds/domain/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:brew_buds/domain/profile/model/saved_note/saved_post.dart';
import 'package:brew_buds/domain/profile/model/saved_note/saved_tasting_record.dart';
import 'package:brew_buds/domain/profile/presenter/tasted_report_presenter.dart';
import 'package:brew_buds/domain/profile/widgets/activity_calendar_builder.dart';
import 'package:brew_buds/domain/profile/widgets/profile_post_item_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_coffee_bean_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_post_widget.dart';
import 'package:brew_buds/domain/profile/widgets/saved_tasting_record_widget.dart';
import 'package:extended_image/extended_image.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
  final GlobalKey _scrollViewKey = GlobalKey();
  final List<GlobalKey> _keyList = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  late final TabController _tabController;
  late final ScrollController _scrollController;

  @override
  void initState() {
    _tabController = TabController(length: 4, vsync: this);
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
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
    return Scaffold(
      appBar: _buildAppBar(),
      body: CustomScrollView(
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
          _buildRatingGraph(),
          SliverToBoxAdapter(child: Container(height: 8, color: ColorStyles.gray20)),
          _buildFlavor(),
          SliverToBoxAdapter(child: Container(height: 8, color: ColorStyles.gray20)),
          _buildCountry(),
        ],
      ),
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
            InkWell(
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
    String countToString(int count) {
      if (count == 0) {
        return '000';
      } else if (count >= 1000 && count < 1000000) {
        return '${count / 1000}.${count / 100}K';
      } else if (count >= 1000000 && count < 1000000000) {
        return '${count / 1000000}.${count / 100000}M';
      } else if (count >= 1000000000) {
        return '${count / 1000000000}.${count / 10000000}G';
      } else {
        return '$count';
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
                const Text('활동 요약', style: TextStyles.title02Bold),
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
                    const Text('시음기록', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(postCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    const Text('게시글', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(savedNoteCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    const Text('저장한 노트', style: TextStyles.captionMediumMedium)
                  ],
                ),
                Column(
                  children: [
                    Text(countToString(savedBeanCount), style: TextStyles.title02Bold),
                    const SizedBox(height: 4),
                    const Text('찜한 원두', style: TextStyles.captionMediumMedium)
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
        overlayColor: const MaterialStatePropertyAll(Colors.transparent),
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
                const Text('활동 캘린더', style: TextStyles.title02Bold),
                const Spacer(),
                Selector<TasteReportPresenter, ActivityTypeState>(
                  selector: (context, presenter) => presenter.activityTypeState,
                  builder: (context, activityTypeState, child) => GestureDetector(
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
    const daysOfWeekTextStyle = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
      height: 16.8 / 14,
      letterSpacing: -0.01,
    );
    return Selector<TasteReportPresenter, DateTime>(
      selector: (context, presenter) => presenter.focusedDay,
      builder: (context, focusedDay, child) => Column(
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
                    SvgPicture.asset('assets/icons/back.svg', height: 24, width: 24),
                    const SizedBox(width: 20),
                    Text('${focusedDay.year}년 ${focusedDay.month}월', style: TextStyles.title01SemiBold),
                    const SizedBox(width: 20),
                    SvgPicture.asset('assets/icons/arrow.svg', height: 24, width: 24),
                  ],
                ),
                GestureDetector(
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
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => false,
            calendarFormat: CalendarFormat.month,
            firstDay: DateTime(1970, 1, 1),
            lastDay: DateTime(2099, 12, 31),
            headerVisible: false,
            daysOfWeekHeight: 44,
            rowHeight: 50,
            availableGestures: AvailableGestures.horizontalSwipe,
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekendStyle: daysOfWeekTextStyle,
              weekdayStyle: daysOfWeekTextStyle,
            ),
            calendarStyle: const CalendarStyle(isTodayHighlighted: false, outsideDaysVisible: false),
            calendarBuilders: ActivityCalendarBuilder(fetchActivityCount: (DateTime day) => 1),
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
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: ColorStyles.gray20)),
        ),
        child: Selector<TasteReportPresenter, ActivityListState>(
          selector: (context, presenter) => presenter.activityListState,
          builder: (context, activityListState, child) {
            return ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: Text(
                '${activityListState.currentActivityType} | ${activityListState.page.results.length}',
                style: TextStyles.labelMediumMedium,
              ),
              iconColor: ColorStyles.black,
              initiallyExpanded: true,
              shape: const Border(),
              collapsedShape: const Border(),
              children: List<Widget>.generate(
                activityListState.page.results.length,
                (index) {
                  final activity = activityListState.page.results[index];
                  if (activity is TastingRecordInProfile) {
                    return GestureDetector(
                      onTap: () {
                        showTastingRecordDetail(context: context, id: activity.id);
                      },
                      child: SavedTastingRecordWidget(
                        beanName: activity.beanName,
                        rating: '4.5',
                        likeCount: '22',
                        flavor: [],
                        imageUri: activity.imageUri,
                      ),
                    );
                  } else if (activity is PostInProfile) {
                    return GestureDetector(
                      onTap: () {
                        showTastingRecordDetail(context: context, id: activity.id);
                      },
                      child: ProfilePostItemWidget(
                        title: activity.title,
                        author: activity.author,
                        createdAt: activity.createdAt,
                        subject: activity.subject,
                      ),
                    );
                  } else if (activity is BeanInProfile) {
                    return SavedCoffeeBeanWidget(
                      name: activity.name,
                      rating: activity.rating,
                      tastedRecordsCount: activity.tastedRecordsCount,
                      imageUri: '',
                    );
                  } else if (activity is SavedPost) {
                    return GestureDetector(
                      onTap: () {
                        showTastingRecordDetail(context: context, id: activity.id);
                      },
                      child: SavedPostWidget(
                        title: activity.title,
                        subject: activity.subject.toString(),
                        createdAt: activity.createdAt,
                        author: activity.author,
                        imageUri: activity.imageUri,
                      ),
                    );
                  } else if (activity is SavedTastingRecord) {
                    return GestureDetector(
                      onTap: () {
                        showTastingRecordDetail(context: context, id: activity.id);
                      },
                      child: SavedTastingRecordWidget(
                        beanName: activity.beanName,
                        rating: '4.5',
                        likeCount: '22',
                        flavor: activity.flavor,
                        imageUri: activity.imageUri,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
                  .separator(
                      separatorWidget: Container(
                    height: 1,
                    color: ColorStyles.gray30,
                  ))
                  .toList(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildRatingGraph() {
    List<String> _test = ['', '0.5', '1.0', '1.5', '2.0', '2.5', '3.0', '3.5', '4.0', '4.5', '5.0', ''];
    return SliverToBoxAdapter(
      child: Column(
        key: _keyList[1],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 16),
            child: Text('별점 분포', style: TextStyles.title02Bold),
          ),
          const SizedBox(height: 24),
          Container(
            height: 100,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BarChart(
              BarChartData(
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 0.00,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 0.15,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 0.01,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 0.01,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 0.40,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 5,
                    barRods: [
                      BarChartRodData(
                        toY: 0.50,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.red,
                        width: 24,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 6,
                    barRods: [
                      BarChartRodData(
                        toY: 0.10,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 7,
                    barRods: [
                      BarChartRodData(
                        toY: 0.20,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 8,
                    barRods: [
                      BarChartRodData(
                        toY: 0.30,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 9,
                    barRods: [
                      BarChartRodData(
                        toY: 0.05,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 10,
                    barRods: [
                      BarChartRodData(
                        toY: 0.01,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                    showingTooltipIndicators: [0],
                  ),
                  BarChartGroupData(
                    x: 11,
                    barRods: [
                      BarChartRodData(
                        toY: 0.00,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                        color: ColorStyles.gray20,
                        width: 24,
                      ),
                    ],
                  ),
                ],
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
                        _test[groupIndex],
                        TextStyles.labelSmallSemiBold.copyWith(
                          color: groupIndex == 5 ? ColorStyles.red : ColorStyles.gray50,
                        ),
                      );
                    },
                  ),
                ),
                borderData: FlBorderData(border: const Border(bottom: BorderSide(color: ColorStyles.gray20, width: 1))),
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
                    Text('5.0', style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red)),
                    const SizedBox(height: 6),
                    const Text('별점 평균', style: TextStyles.captionMediumMedium),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('32', style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red)),
                    const SizedBox(height: 6),
                    const Text('별점 개수', style: TextStyles.captionMediumMedium),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('4.0', style: TextStyles.title04SemiBold.copyWith(color: ColorStyles.red)),
                    const SizedBox(height: 6),
                    const Text('주요 별점', style: TextStyles.captionMediumMedium),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildFlavor() {
    return SliverToBoxAdapter(
      child: Padding(
        key: _keyList[2],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 16),
              child: Text('선호하는 맛', style: TextStyles.title02Bold),
            ),
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
                        sections: [
                          PieChartSectionData(
                            radius: 30,
                            value: 46.90,
                            color: ColorStyles.red,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 22.10,
                            color: ColorStyles.gray40,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 16.20,
                            color: ColorStyles.gray30,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 9.60,
                            color: ColorStyles.gray20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 5.20,
                            color: ColorStyles.gray10,
                            showTitle: false,
                          ),
                        ],
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
                            const Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                height: 38.4 / 32,
                                letterSpacing: -0.01,
                                color: ColorStyles.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('위', style: TextStyles.title02Bold.copyWith(color: ColorStyles.red)),
                          ],
                        ),
                        const Text('트로피칼', style: TextStyles.title02Bold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.red),
                          borderRadius: BorderRadius.circular(20),
                          color: ColorStyles.background,
                        ),
                        child: Text(
                          '트로피칼',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.red),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '46.90%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.red),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray40,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '꽃',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '22.10%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '초콜릿',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '16.20%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '부드러움',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '9.60%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray10,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '상큼',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '5.20%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                ].separator(separatorWidget: const SizedBox(height: 16)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: ColorStyles.gray10,
                child: const Text(
                  '선호하는 맛은 회원님이 3.5점 이상으로 평가한 원두의 맛에, 별점에 따른 가중치를 부여한 뒤 가중 평균을 계산하여 그 결과를 바탕으로 최소 1개, 최대 5개의 맛까지 순위대로 나타냅니다.',
                  maxLines: null,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
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

  Widget _buildCountry() {
    return SliverToBoxAdapter(
      child: Padding(
        key: _keyList[3],
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24, bottom: 16),
              child: Text('선호하는 원산지', style: TextStyles.title02Bold),
            ),
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
                        sections: [
                          PieChartSectionData(
                            radius: 30,
                            value: 46.90,
                            color: ColorStyles.red,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 22.10,
                            color: ColorStyles.gray40,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 16.20,
                            color: ColorStyles.gray30,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 9.60,
                            color: ColorStyles.gray20,
                            showTitle: false,
                          ),
                          PieChartSectionData(
                            radius: 30,
                            value: 5.20,
                            color: ColorStyles.gray10,
                            showTitle: false,
                          ),
                        ],
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
                            const Text(
                              '1',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 32,
                                height: 38.4 / 32,
                                letterSpacing: -0.01,
                                color: ColorStyles.red,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text('위', style: TextStyles.title02Bold.copyWith(color: ColorStyles.red)),
                          ],
                        ),
                        const Text('에티오피아', style: TextStyles.title02Bold),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.red,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.red),
                          borderRadius: BorderRadius.circular(20),
                          color: ColorStyles.background,
                        ),
                        child: Text(
                          '에티오피아',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.red),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '46.90%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.red),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray40,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '케냐',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '22.10%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray30,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '콜롬비아',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '16.20%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray20,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '코스타리카',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '9.60%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 22,
                        width: 22,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorStyles.gray10,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray60),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '온두라스',
                          style: TextStyles.captionMediumMedium.copyWith(color: ColorStyles.gray60),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Text(
                          '5.20%',
                          style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.gray60),
                        ),
                      )
                    ],
                  ),
                ].separator(separatorWidget: const SizedBox(height: 16)).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Container(
                padding: const EdgeInsets.all(8),
                color: ColorStyles.gray10,
                child: const Text(
                  '선호하는 맛은 회원님이 3.5점 이상으로 평가한 원두의 맛에, 별점에 따른 가중치를 부여한 뒤 가중 평균을 계산하여 그 결과를 바탕으로 최소 1개, 최대 5개의 맛까지 순위대로 나타냅니다.',
                  maxLines: null,
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
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
                  padding: const EdgeInsets.only(bottom: 64),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                            const Text('활동 보기', style: TextStyles.title02SemiBold),
                            const Spacer(),
                            InkWell(
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
                      const SizedBox(height: 8),
                      ...List.generate(activityTypeList.length, (index) {
                        final type = activityTypeList[index];
                        return GestureDetector(
                          onTap: () => context.pop(index),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                            child: type == currentActivityType
                                ? Row(
                                    children: [
                                      Text(type, style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.red)),
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
                      }),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    if (result != null && context.mounted) {
      context.read<TasteReportPresenter>().onChangeActivityType(result as int);
    }
  }
}
