import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/analytics_manager.dart';
import 'package:brew_buds/core/center_dialog_mixin.dart';
import 'package:brew_buds/core/screen_navigator.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/views/login_bottom_sheet.dart';
import 'package:brew_buds/domain/login/widgets/terms_of_use_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

enum CoffeeNote {
  post,
  tastedRecord;
}

class MainView extends StatefulWidget {
  final Widget child;
  final bool isHideBottomBar;

  const MainView({
    super.key,
    required this.child,
    required this.isHideBottomBar,
  });

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with CenterDialogMixin<MainView> {
  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();

  int get currentIndex => getCurrentIndex(context);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (SharedPreferencesRepository.instance.isFirst) {
        ShowCaseWidget.of(context).startShowCase([_one, _two, _three]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isGuest = context.select<AccountRepository, bool>((repository) => repository.isGuest);
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: widget.isHideBottomBar
          ? null
          : Container(
              color: ColorStyles.white,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 24, top: 8, left: 32, right: 32),
                  child: Row(
                    children: List.generate(
                      4,
                      (index) {
                        final isSelect = currentIndex == index;
                        if (index == 0) {
                          return ThrottleButton(
                            onTap: () {
                              AnalyticsManager.instance.logButtonTap(buttonName: 'gnb_home');
                              context.go('/home');
                            },
                            child: _buildBottomNavigationItem(
                              icon: SvgPicture.asset(
                                isSelect ? 'assets/icons/home_fill.svg' : 'assets/icons/home.svg',
                                width: 24,
                                height: 24,
                              ),
                              title: '홈',
                              isSelect: isSelect,
                            ),
                          );
                        } else if (index == 1) {
                          return Showcase(
                            key: _one,
                            title: '내게 맞는 원두를 찾아보세요!',
                            titleTextStyle: TextStyles.title01Bold,
                            titleAlignment: Alignment.centerLeft,
                            titlePadding: const EdgeInsets.only(bottom: 4),
                            description: '추천 원두를 확인하고,\n버디/시음기록/게시글을 검색할 수 있어요.',
                            descTextStyle: TextStyles.bodyRegular,
                            disableMovingAnimation: true,
                            toolTipMargin: 48,
                            tooltipPadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                            tooltipActionConfig: const TooltipActionConfig(
                                gapBetweenContentAndAction: 12, crossAxisAlignment: CrossAxisAlignment.center),
                            tooltipActions: [
                              TooltipActionButton(
                                type: TooltipDefaultActionType.previous,
                                name: '1/3',
                                backgroundColor: ColorStyles.white,
                                textStyle: TextStyles.captionMediumMedium,
                                borderRadius: BorderRadius.zero,
                                padding: EdgeInsets.zero,
                                onTap: () {},
                              ),
                              TooltipActionButton(
                                type: TooltipDefaultActionType.next,
                                name: '다음',
                                backgroundColor: ColorStyles.black,
                                textStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              )
                            ],
                            targetBorderRadius: const BorderRadius.all(Radius.circular(8)),
                            targetPadding: const EdgeInsets.all(8),
                            child: ThrottleButton(
                              onTap: () async {
                                AnalyticsManager.instance.logButtonTap(buttonName: 'gnb_search');
                                if (isGuest) {
                                  showLoginBottomSheet(onLogin: () {
                                    context.go('/search');
                                  });
                                } else {
                                  context.go('/search');
                                }
                              },
                              child: _buildBottomNavigationItem(
                                icon: SvgPicture.asset(
                                  isSelect ? 'assets/icons/search_fill.svg' : 'assets/icons/search.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                title: '검색',
                                isSelect: isSelect,
                              ),
                            ),
                          );
                        } else if (index == 2) {
                          return Showcase(
                            key: _two,
                            title: '커피노트를 작성해보세요!',
                            titleTextStyle: TextStyles.title01Bold,
                            titleAlignment: Alignment.centerLeft,
                            titlePadding: const EdgeInsets.only(bottom: 4),
                            description: '마신 커피를 기록하거나,\n게시글을 업로드할 수 있어요.',
                            descTextStyle: TextStyles.bodyRegular,
                            disableMovingAnimation: true,
                            tooltipPadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                            tooltipActionConfig: const TooltipActionConfig(
                                gapBetweenContentAndAction: 12, crossAxisAlignment: CrossAxisAlignment.center),
                            tooltipActions: [
                              TooltipActionButton(
                                type: TooltipDefaultActionType.previous,
                                name: '2/3',
                                backgroundColor: ColorStyles.white,
                                textStyle: TextStyles.captionMediumMedium,
                                borderRadius: BorderRadius.zero,
                                padding: EdgeInsets.zero,
                                onTap: () {},
                              ),
                              TooltipActionButton(
                                type: TooltipDefaultActionType.next,
                                name: '다음',
                                backgroundColor: ColorStyles.black,
                                textStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              )
                            ],
                            targetBorderRadius: const BorderRadius.all(Radius.circular(8)),
                            targetPadding: const EdgeInsets.all(8),
                            child: ThrottleButton(
                              onTap: () async {
                                AnalyticsManager.instance.logButtonTap(buttonName: 'gnb_records');
                                if (isGuest) {
                                  showLoginBottomSheet(onLogin: () {
                                    showCoffeeNoteBottomSheet();
                                  });
                                } else {
                                  showCoffeeNoteBottomSheet();
                                }
                              },
                              child: _buildBottomNavigationItem(
                                icon: SvgPicture.asset(
                                  isSelect ? 'assets/icons/coffee_note_fill.svg' : 'assets/icons/coffee_note.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                title: '커피노트',
                                isSelect: isSelect,
                              ),
                            ),
                          );
                        } else {
                          return Showcase(
                            key: _three,
                            title: '나의 커피 취향을 확인해보세요!',
                            titleTextStyle: TextStyles.title01Bold,
                            titleAlignment: Alignment.centerLeft,
                            titlePadding: const EdgeInsets.only(bottom: 4),
                            description: '취향 리포트와 저장한 원두,\n시음기록, 게시글을 확인해보세요.',
                            descTextStyle: TextStyles.bodyRegular,
                            disableMovingAnimation: true,
                            tooltipPadding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 16),
                            tooltipActionConfig: const TooltipActionConfig(
                                gapBetweenContentAndAction: 12, crossAxisAlignment: CrossAxisAlignment.center),
                            tooltipActions: [
                              TooltipActionButton(
                                type: TooltipDefaultActionType.previous,
                                name: '3/3',
                                backgroundColor: ColorStyles.white,
                                textStyle: TextStyles.captionMediumMedium,
                                borderRadius: BorderRadius.zero,
                                padding: EdgeInsets.zero,
                                onTap: () {},
                              ),
                              TooltipActionButton(
                                type: TooltipDefaultActionType.next,
                                name: '다음',
                                backgroundColor: ColorStyles.black,
                                textStyle: TextStyles.labelSmallMedium.copyWith(color: ColorStyles.white),
                                borderRadius: const BorderRadius.all(Radius.circular(20)),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              )
                            ],
                            targetBorderRadius: const BorderRadius.all(Radius.circular(8)),
                            targetPadding: const EdgeInsets.all(8),
                            child: ThrottleButton(
                              onTap: () async {
                                AnalyticsManager.instance.logButtonTap(buttonName: 'gnb_profile');
                                if (isGuest) {
                                  showLoginBottomSheet(onLogin: () {
                                    context.go('/profile');
                                  });
                                } else {
                                  context.go('/profile');
                                }
                              },
                              child: _buildBottomNavigationItem(
                                icon: SvgPicture.asset(
                                  isSelect ? 'assets/icons/profile_fill.svg' : 'assets/icons/profile.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                title: '프로필',
                                isSelect: isSelect,
                              ),
                            ),
                          );
                        }
                      },
                    ).separator(separatorWidget: const Spacer()).toList(),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildBottomNavigationItem({required Widget icon, required String title, required bool isSelect}) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: icon,
          ),
          const SizedBox(height: 2),
          Text(
            title,
            style: TextStyles.captionSmallMedium.copyWith(color: isSelect ? ColorStyles.red : ColorStyles.black),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  int getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  showCoffeeNoteBottomSheet() async {
    final context = this.context;
    final coffeeNoteResult = await showBarrierDialog<CoffeeNote>(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return _buildCoffeeNoteBottomSheet(context);
      },
    );

    if (context.mounted) {
      switch (coffeeNoteResult) {
        case null:
          break;
        case CoffeeNote.post:
          ScreenNavigator.showPostWriteScreen(context: context);
          break;
        case CoffeeNote.tastedRecord:
          await ScreenNavigator.showTastedRecordWriteScreen(context);
          break;
      }
    }
  }

  Widget _buildCoffeeNoteBottomSheet(BuildContext context) {
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
                    child: Text(
                      '커피노트 작성하기',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 22 / 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  ThrottleButton(
                    onTap: () {
                      context.pop(CoffeeNote.post);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                          border: Border(bottom: BorderSide(color: ColorStyles.gray10)), color: Colors.transparent),
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
                                Text('게시글', style: TextStyles.title01SemiBold),
                                const SizedBox(height: 4),
                                Text(
                                  '자유롭게 내 커피 생활을 공유해 보세요',
                                  style: TextStyles.bodyNarrowRegular.copyWith(color: ColorStyles.gray50),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ThrottleButton(
                    onTap: () {
                      context.pop(CoffeeNote.tastedRecord);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      color: Colors.transparent,
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
                                Text('시음기록', style: TextStyles.title01SemiBold),
                                const SizedBox(height: 4),
                                Text(
                                  '오늘은 어떤 커피를 드셨나요?',
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
                    child: ThrottleButton(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: ColorStyles.black,
                        ),
                        child: Center(
                          child: Text(
                            '닫기',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              height: 16.71 / 14,
                              letterSpacing: -0.01,
                              color: ColorStyles.white,
                            ),
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
  }

  showLoginBottomSheet({required void Function() onLogin}) async {
    final context = this.context;
    final result = await showBarrierDialog<LoginResult>(
      context: context,
      pageBuilder: (context, _, __) => LoginBottomSheet.buildWithPresenter(),
    );

    if (result != null && context.mounted) {
      switch (result) {
        case LoginSuccess():
          onLogin.call();
          break;
        case NeedToSignUp():
          final checkResult = await _checkModal(context);
          if (checkResult != null && checkResult && context.mounted) {
            AccountRepository.instance.saveTokenAndIdInMemory(
              id: result.id,
              accessToken: result.accessToken,
              refreshToken: result.refreshToken,
            );
            context.go('/login/signup/1');
          }
          break;
      }
    }
  }

  Future<bool?> _checkModal(BuildContext context) {
    return showBarrierDialog<bool>(
      context: context,
      pageBuilder: (context, _, __) {
        return const TermsOfUseBottomSheet();
      },
    );
  }
}
