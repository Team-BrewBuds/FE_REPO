import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/profile/widgets/like_flaver_wdgt.dart';
import 'package:brew_buds/profile/widgets/like_nation_wdgt.dart';
import 'package:brew_buds/profile/widgets/no_data_wdgt.dart';
import 'package:brew_buds/profile/widgets/score_wdgt.dart';
import 'package:flutter/material.dart';

import '../widgets/calendarWidget.dart';


class ScrollControlledTabBar extends StatefulWidget {
  @override
  _ScrollControlledTabBarState createState() => _ScrollControlledTabBarState();
}

class _ScrollControlledTabBarState extends State<ScrollControlledTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _scrollController;
  final List<dynamic> _starScore = [];
  final List<dynamic> _flaver = [];
  final List<dynamic> _origin = [];


  @override
  void initState() {
    super.initState();

    // 탭 컨트롤러 초기화 (4개의 탭)
    _tabController = TabController(length: 4, vsync: this);

    // 스크롤 컨트롤러 초기화
    _scrollController = ScrollController();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // 스크롤 위치에 따라 탭바 업데이트
  void _handleScroll() {
    if (!_tabController.indexIsChanging) {
      if (_scrollController.position.pixels >= 0 &&
          _scrollController.position.pixels < 500) {
        _tabController.animateTo(1);
      } else if (_scrollController.position.pixels >= 500 &&
          _scrollController.position.pixels < 1000) {
        _tabController.animateTo(2);
      } else if (_scrollController.position.pixels >= 1000 &&
          _scrollController.position.pixels < 1500) {
        _tabController.animateTo(3);
      } else if (_scrollController.position.pixels >= 1500) {
        _tabController.animateTo(4);
      }
    }
  }



  bool _isScrolling = false;

  void _handleTabChange() {
    if (!_isScrolling) {
      _isScrolling = true;
      double scrollPosition = _tabController.index * 500.0;
      _scrollController.animateTo(
          scrollPosition,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut
      ).then((_) {
        _isScrolling = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: AppBar(
            bottom: TabBar(
              controller: _tabController,
              onTap: (_) => _handleTabChange(),
              labelColor: Colors.black,
                indicatorColor: Colors.black,
              tabs: [
                Tab(text: '활동 캘린더'),
                Tab(text: '별점 분포'),
                Tab(text: '선호 맛'),
                Tab(text: '선호 원산지'),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              KoreanCalendarPage(),
              Divider(thickness:8.0, color: ColorStyles.gray20,),
              Scorewidget(scoreData: _starScore, ),
              Divider(thickness:8.0, color: ColorStyles.gray20,),
              LikeFlaverWdgt(data: _flaver,),
              Divider(thickness:8.0, color: ColorStyles.gray20,),
              LikeNationWdgt(data: _origin,)
            ],
          ),
        ),
      ),
    );
  }

  // 섹션 빌더
  Widget _buildSection(Color color, double height, String text) {
    return Container(
      color: color,
      height: height,
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: Colors.red, fontSize: 24),
        ),
      ),
    );
  }
}
