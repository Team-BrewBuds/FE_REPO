import 'package:brew_buds/common/button_factory.dart';
import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/icon_button_factory.dart';
import 'package:brew_buds/common/iterator_widget_ext.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileView extends StatefulWidget {
  final Widget child;

  const ProfileView({
    super.key,
    required this.child,
  });

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  int currentIndex = 0;
  bool isRefresh = false;
  late final ScrollController scrollController;

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 0,
      child: SafeArea(
        child: CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverAppBar(
              titleSpacing: 0,
              pinned: true,
              title: Padding(
                padding: EdgeInsets.only(top: 28, left: 16, right: 16, bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('출근하자마자커피한잔'),
                    Spacer(),
                    InkWell(
                      onTap: () {},
                      child: SvgPicture.asset(
                        'assets/icons/setting.svg',
                        fit: BoxFit.cover,
                        height: 24,
                        width: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: BoxShape.circle,
                          ),
                          child: Container(),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  children: [
                                    Text('000', style: TextStyles.captionMediumMedium,),
                                    SizedBox(height: 6),
                                    Text('시음기록', style: TextStyles.captionMediumRegular,),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('000', style: TextStyles.captionMediumMedium,),
                                    SizedBox(height: 6),
                                    Text('팔로워', style: TextStyles.captionMediumRegular,),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text('000', style: TextStyles.captionMediumMedium,),
                                    SizedBox(height: 6),
                                    Text('팔로잉', style: TextStyles.captionMediumRegular,),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 6),
                          decoration: BoxDecoration(
                            color: ColorStyles.gray20,
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                          ),
                          child: Row(
                            children: [
                              Text('버디님이 즐기는 커피 생활을 알려주세요', style: TextStyles.captionMediumRegular),
                              InkWell(
                                onTap: () {},
                                child: SvgPicture.asset('assets/icons/arrow.svg', height: 18, width: 18),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: [
                        ButtonFactory.buildRoundedButton(
                          onTapped: () {},
                          text: '취향 리포트 보기',
                          style: RoundedButtonStyle.fill(
                            size: RoundedButtonSize.medium,
                            color: ColorStyles.black,
                            textColor: ColorStyles.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        ButtonFactory.buildRoundedButton(
                          onTapped: () {},
                          text: '프로필 편집',
                          style: RoundedButtonStyle.fill(
                            size: RoundedButtonSize.medium,
                            color: ColorStyles.gray30,
                            textColor: ColorStyles.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SliverAppBar(
              floating: true,
              titleSpacing: 0,
              title: TabBar(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
                indicatorWeight: 2,
                indicatorPadding: const EdgeInsets.only(top: 4),
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorColor: ColorStyles.black,
                labelPadding: const EdgeInsets.only(top: 8),
                labelStyle: TextStyles.title01SemiBold,
                labelColor: ColorStyles.black,
                unselectedLabelStyle: TextStyles.title01SemiBold,
                unselectedLabelColor: ColorStyles.gray50,
                dividerHeight: 0,
                overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                tabs: const [
                  Tab(text: '시음기록', height: 31),
                  Tab(text: '게시글', height: 31),
                  Tab(text: '찜한 원두', height: 31),
                  Tab(text: '저장한 노트', height: 31),
                ],
                onTap: (index) {
                  if (currentIndex == index) {
                    setState(() {
                      isRefresh = true;
                    });
                    Future.delayed(Duration(milliseconds: 100)).whenComplete(() {
                      setState(() {
                        isRefresh = false;
                      });
                    });
                  } else {
                    setState(() {
                      currentIndex = index;
                    });
                  }
                },
              ),
            ),
            SliverToBoxAdapter(child: Container(height: 1, width: double.infinity, color: ColorStyles.gray30)),
            SliverAppBar(
              titleSpacing: 0,
              floating: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 8, bottom: 4, left: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/arrow_up_down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '최근저장순',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 8, bottom: 4, left: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/union.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              '필터',
                              style: TextStyles.captionMediumRegular,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 4, bottom: 4, left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '원두유형',
                              style: TextStyles.captionMediumRegular,
                            ),
                            SizedBox(width: 2),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 4, bottom: 4, left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '생산 국가',
                              style: TextStyles.captionMediumRegular,
                            ),
                            SizedBox(width: 2),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 4, bottom: 4, left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '평균 별점',
                              style: TextStyles.captionMediumRegular,
                            ),
                            SizedBox(width: 2),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 4, bottom: 4, left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '로스팅 포인트',
                              style: TextStyles.captionMediumRegular,
                            ),
                            SizedBox(width: 2),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 4, right: 4, bottom: 4, left: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: ColorStyles.gray70, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '디카페인',
                              style: TextStyles.captionMediumRegular,
                            ),
                            SizedBox(width: 2),
                            InkWell(
                              onTap: () {},
                              child: SvgPicture.asset(
                                'assets/icons/down.svg',
                                height: 18,
                                width: 18,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ].separator(separatorWidget: SizedBox(width: 4)).toList(),
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              child: isRefresh ? Container() : _buildGridView(),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    switch (currentIndex) {
      case 0:
        return Center(child: Text('첫 시음기록을 작성해 보세요.', style: TextStyles.bodyRegular));
      case 1:
        return Center(child: Text('첫 게시글을 작성해 보세요.', style: TextStyles.bodyRegular));
      case 2:
        return Center(child: Text('찜한 원두가 없습니다.', style: TextStyles.bodyRegular));
      case 3:
        return Center(child: Text('저장한 노트가 없습니다.', style: TextStyles.bodyRegular));
      default:
        return Container();
    }
  }
}
