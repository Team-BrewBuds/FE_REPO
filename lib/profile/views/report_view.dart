import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/profile/views/scrollTabpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/text_styles.dart';
import '../widgets/calendarWidget.dart';

class ProfileReportView extends StatefulWidget {
  const ProfileReportView({super.key});

  @override
  State<ProfileReportView> createState() => _ProfileReportViewState();
}

class _ProfileReportViewState extends State<ProfileReportView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // TabController 생성 (length: 4, vsync: this)
    _tabController = TabController(length: 4, vsync: this);
    // PageController 생성
    _pageController = PageController();

    // PageController의 페이지를 변경할 때 TabBar도 이동하도록 설정
    _pageController.addListener(() {
      int currentPage = _pageController.page?.round() ?? 0;
      if (_tabController.index != currentPage) {
        _tabController.animateTo(currentPage);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('nickName')),
      body: Expanded(
        child: Column(
          children: [
            Container(
              height: 100.0,
              color: Colors.grey[200],
            ),
            Container(
                color: Colors.grey[100],
                height: 105.0,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('활동요약'),
                          Row(
                            children: [
                              Icon(CupertinoIcons.info,size: 13.0,color: ColorStyles.gray50,),
                              Text(
                                '최근 1개월간 브루버즈에서의 활동을 요약했어요.',
                                style: TextStyles.textlightSmall,
                              )
                            ],
                          ),

                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '000',
                                  style: TextStyles.title02Bold,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '시음기록',
                                  style: TextStyles.title01Bold,
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '000',
                                  style: TextStyles.title02Bold,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '게시글',
                                  style: TextStyles.title01Bold,
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '000',
                                  style: TextStyles.title02Bold,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '저장한 노트',
                                  style: TextStyles.title01Bold,
                                )
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  '000',
                                  style: TextStyles.title02Bold,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  '찜한 원두',
                                  style: TextStyles.title01Bold,
                                )
                              ],
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                )),
            Expanded(child: ScrollControlledTabBar())
          ],
        ),
      ),
    );
  }



  Widget _ratingDistributionScreen() {
    return Center(child: Text("별점 분포", style: TextStyle(fontSize: 24)));
  }

  Widget _preferredTasteScreen() {
    return Center(child: Text("선호 맛", style: TextStyle(fontSize: 24)));
  }

  Widget _preferredOriginScreen() {
    return Center(child: Text("선호 원산지", style: TextStyle(fontSize: 24)));
  }
}
