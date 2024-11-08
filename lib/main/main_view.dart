import 'package:brew_buds/common/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatefulWidget {
  final StatefulNavigationShell _navigationShell;

  const MainView({
    super.key,
    required StatefulNavigationShell navigationShell,
  }) : _navigationShell = navigationShell;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget._navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: widget._navigationShell.currentIndex,
            items: [
              BottomNavigationBarItem(
                icon: _createSvgIcon(path: 'assets/icons/home.svg'),
                activeIcon: _createSvgIcon(path: 'assets/icons/home_fill.svg', isActive: true),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: _createSvgIcon(path: 'assets/icons/search.svg'),
                activeIcon: _createSvgIcon(path: 'assets/icons/search_fill.svg', isActive: true),
                label: '검색',
              ),
              BottomNavigationBarItem(
                icon: _createSvgIcon(path: 'assets/icons/coffee_note.svg'),
                activeIcon: _createSvgIcon(path: 'assets/icons/coffee_note_fill.svg', isActive: true),
                label: '커피기록',
              ),
              BottomNavigationBarItem(
                icon: _createSvgIcon(path: 'assets/icons/profile.svg'),
                activeIcon: _createSvgIcon(path: 'assets/icons/profile_fill.svg', isActive: true),
                label: '프로필',
              ),
            ],
            backgroundColor: ColorStyles.white,
            selectedItemColor: ColorStyles.red,
            unselectedItemColor: ColorStyles.black,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            elevation: 0,
            enableFeedback: false,
            onTap: (int index) => widget._navigationShell.goBranch(index),
          ),
        ),
      ),
    );
  }

  SvgPicture _createSvgIcon({required String path, bool isActive = false}) {
    return SvgPicture.asset(
      path,
      height: 24,
      width: 24,
      colorFilter: ColorFilter.mode(
        isActive ? ColorStyles.red : ColorStyles.black,
        BlendMode.srcIn,
      ),
    );
  }
}


