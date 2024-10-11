import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/home/widgets/alarm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  final StatefulNavigationShell _navigationShell;

  const HomeView({
    super.key,
    required StatefulNavigationShell navigationShell,
  }) : _navigationShell = navigationShell;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: widget._navigationShell.currentIndex,
      child: SafeArea(
        child: Scaffold(
          appBar: _buildAppBar(context),
          body: widget._navigationShell,
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: false,
      titleSpacing: 0,
      toolbarHeight: 68,
      title: SizedBox(
        height: 68,
        child: Stack(
          children: [
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/logo.svg',
                    width: 130,
                  ),
                  const Spacer(),
                  const Alarm(hasNewAlarm: false),
                ],
              ),
            ),
          ],
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(47),
        child: TabBar(
          padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
          indicator: const UnderlineTabIndicator(borderSide: BorderSide(color: ColorStyles.black)),
          indicatorWeight: 2,
          indicatorPadding: const EdgeInsets.only(top: 2, bottom: 8),
          labelPadding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          labelStyle: TextStyles.titleLargeSemiBold,
          labelColor: ColorStyles.black,
          unselectedLabelStyle: TextStyles.titleLargeSemiBold,
          unselectedLabelColor: ColorStyles.gray50,
          dividerColor: Colors.white,
          overlayColor: const MaterialStatePropertyAll(Colors.transparent),
          tabs: const [
            Tab(text: '전체', height: 31),
            Tab(text: '시음기록', height: 31),
            Tab(text: '게시글', height: 31),
          ],
          onTap: widget._navigationShell.goBranch,
        ),
      ),
    );
  }
}
