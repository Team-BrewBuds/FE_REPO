import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/home/all/home_all_presenter.dart';
import 'package:brew_buds/domain/home/all/home_all_view.dart';
import 'package:brew_buds/domain/home/post/home_post_presenter.dart';
import 'package:brew_buds/domain/home/post/home_post_view.dart';
import 'package:brew_buds/domain/home/tasting_record/home_tasting_record_presenter.dart';
import 'package:brew_buds/domain/home/tasting_record/home_tasting_record_view.dart';
import 'package:brew_buds/domain/home/widgets/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<NestedScrollViewState> nestedScrollViewState;

  const HomeView({
    super.key,
    required this.nestedScrollViewState,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool isRefresh = false;
  int currentIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
        key: widget.nestedScrollViewState,
        floatHeaderSlivers: true,
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 130,
                  ),
                  const Spacer(),
                  Alarm(
                    hasNewAlarm: false,
                    onTapped: () {},
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            floating: true,
            forceElevated: innerBoxIsScrolled,
            titleSpacing: 0,
            title: TabBar(
              controller: _tabController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2, color: ColorStyles.black),
                insets: EdgeInsets.only(top: 4),
              ),
              labelPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
              tabAlignment: TabAlignment.start,
              isScrollable: true,
              labelStyle: TextStyles.title02SemiBold,
              labelColor: ColorStyles.black,
              unselectedLabelStyle: TextStyles.title02SemiBold,
              unselectedLabelColor: ColorStyles.gray50,
              dividerColor: Colors.white,
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              tabs: const [
                Tab(text: '전체', height: 31),
                Tab(text: '시음기록', height: 31),
                Tab(text: '게시글', height: 31),
              ],
              onTap: (index) {
                widget.nestedScrollViewState.currentState?.outerController.jumpTo(0);
                if (index == 0) {
                  context.read<HomeAllPresenter>().onRefresh();
                } else if (index == 1) {
                  context.read<HomeTastingRecordPresenter>().onRefresh();
                } else {
                  context.read<HomePostPresenter>().onRefresh();
                }
              },
            ),
          )
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            HomeAllView(scrollController: widget.nestedScrollViewState.currentState?.innerController),
            HomeTastingRecordView(scrollController: widget.nestedScrollViewState.currentState?.innerController),
            HomePostView(
              scrollController: widget.nestedScrollViewState.currentState?.innerController,
              scrollToTop: () {
                widget.nestedScrollViewState.currentState?.outerController.jumpTo(0);
              },
            ),
          ],
        ),
      ),
    );
  }
}
