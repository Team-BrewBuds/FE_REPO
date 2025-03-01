import 'package:animations/animations.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/photo/album_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  final StatefulNavigationShell _navigationShell;

  const MainView({
    super.key,
    required StatefulNavigationShell navigationShell,
  }) : _navigationShell = navigationShell;

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with AutomaticKeepAliveClientMixin {
  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget._navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10.5, top: 8, left: 6, right: 6),
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
                label: '커피노트',
              ),
              BottomNavigationBarItem(
                icon: _createSvgIcon(path: 'assets/icons/profile.svg'),
                activeIcon: _createSvgIcon(path: 'assets/icons/profile_fill.svg', isActive: true),
                label: '프로필',
              ),
            ],
            iconSize: 24,
            backgroundColor: ColorStyles.white,
            selectedItemColor: ColorStyles.red,
            unselectedItemColor: ColorStyles.black,
            selectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500),
            elevation: 0,
            enableFeedback: false,
            onTap: (int index) {
              if (index == 2) {
                showCoffeeNoteBottomSheet();
              } else {
                widget._navigationShell.goBranch(index);
              }
            },
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

  showCoffeeNoteBottomSheet() {
    showBarrierDialog(
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
                  padding: const EdgeInsets.only(bottom: 30),
                  decoration: const BoxDecoration(
                    color: ColorStyles.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: ColorStyles.gray10)),
                        ),
                        child: const Text(
                          '커피노트 작성하기',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 22 / 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      buildTastingRecordWriteScreen(
                        closeBuilder: (context, _) {
                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: const BoxDecoration(
                              border: Border(bottom: BorderSide(color: ColorStyles.gray10)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(12)),
                                    color: ColorStyles.gray10,
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      'assets/icons/post_fill.svg',
                                      height: 28,
                                      width: 28,
                                      colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      const Text('게시글', style: TextStyles.title01SemiBold),
                                      const SizedBox(height: 4),
                                      Text(
                                        '자유롭게 커피에 대한 것을 공유해보세요 ',
                                        style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.gray50),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        onClosed: (_) {
                          context.pop();
                        }
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                height: 48,
                                width: 48,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(12)),
                                  color: ColorStyles.gray10,
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    'assets/icons/coffee_note_fill.svg',
                                    height: 28,
                                    width: 28,
                                    colorFilter: const ColorFilter.mode(ColorStyles.red, BlendMode.srcIn),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const Text('시음기록', style: TextStyles.title01SemiBold),
                                    const SizedBox(height: 4),
                                    Text(
                                      '어떤 커피를 드셨나요?',
                                      style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.gray50),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 24, right: 42, left: 42, bottom: 16),
                        child: GestureDetector(
                          onTap: () {
                            context.pop();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: ColorStyles.black,
                            ),
                            child: const Center(
                              child: Text(
                                '닫기',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 16.71 / 14,
                                    letterSpacing: -0.01,
                                    color: ColorStyles.white),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
