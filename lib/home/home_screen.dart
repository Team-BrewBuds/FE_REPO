import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/home/widgets/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  final GlobalKey<NestedScrollViewState> nestedScrollViewState;
  final Widget child;

  const HomeView({
    super.key,
    required this.nestedScrollViewState,
    required this.child,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool isRefresh = false;
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: NestedScrollView(
          key: widget.nestedScrollViewState,
          floatHeaderSlivers: true,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
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
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: ColorStyles.black)),
                indicatorWeight: 2,
                indicatorPadding: const EdgeInsets.only(top: 2, bottom: 8),
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
                    currentIndex = index;
                    switch (index) {
                      case 0:
                        context.go('/home/all');
                        break;
                      case 1:
                        context.go('/home/tastingRecord');
                        break;
                      case 2:
                        context.go('/home/post');
                        break;
                    }
                  }
                },
              ),
            )
          ],
          body: isRefresh ? Container() : widget.child,
        ),
      ),
    );
  }
}
