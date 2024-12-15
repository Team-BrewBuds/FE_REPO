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
        _tabController.animateTo(0);
      } else if (_scrollController.position.pixels >= 500 &&
          _scrollController.position.pixels < 1000) {
        _tabController.animateTo(1);
      } else if (_scrollController.position.pixels >= 1000 &&
          _scrollController.position.pixels < 1500) {
        _tabController.animateTo(2);
      } else if (_scrollController.position.pixels >= 1500) {
        _tabController.animateTo(3);
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
              Column(
                children: [
                  KoreanCalendarPage(),
                  ListTile(
                    title: Text('1'),
                  ),
                  ListTile(
                    title: Text('1'),
                  )
                ],
              ),

              // _buildSection(Colors.green, 500, 'Section 2'),
              // _buildSection(Colors.blue, 500, 'Section 3'),
              // _buildSection(Colors.orange, 500, 'Section 4'),
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
