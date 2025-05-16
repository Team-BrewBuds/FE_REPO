import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/analytics_manager.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/domain/signup/sign_up_presenter.dart';
import 'package:brew_buds/exception/signup_exception.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const SignupScreen({super.key, required this.navigationShell});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  onPop() {
    final pageIndex = widget.navigationShell.currentIndex;
    if (pageIndex == 0) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userinfo_back');
      context.pop();
    } else if (pageIndex == 1) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_life_back');
      widget.navigationShell.goBranch(pageIndex - 1);
    } else if (pageIndex == 2) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_cert_back');
      widget.navigationShell.goBranch(pageIndex - 1);
    } else {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_taste_back');
      widget.navigationShell.goBranch(pageIndex - 1);
    }
  }

  onSkip() {
    final pageIndex = widget.navigationShell.currentIndex;
    if (pageIndex == 1) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_life_skip');
      context.read<SignUpPresenter>().resetCertificated();
      widget.navigationShell.goBranch(pageIndex + 1);
    } else if (pageIndex == 2) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_cert_skip');
      context.read<SignUpPresenter>().resetPreferredBeanTaste();
      widget.navigationShell.goBranch(pageIndex + 1);
    } else if (pageIndex == 3) {
      AnalyticsManager.instance.logButtonTap(buttonName: 'signup_userprefer_taste_skip');
      context.go('/login/signup/finish?nickname=${context.read<SignUpPresenter>().nickName}');
    }
  }

  onNext() {
    final pageIndex = widget.navigationShell.currentIndex;
    if (pageIndex == 0) {
      context.read<SignUpPresenter>().resetCoffeeLifes();
      widget.navigationShell.goBranch(pageIndex + 1);
    } else if (pageIndex == 1) {
      context.read<SignUpPresenter>().resetCertificated();
      widget.navigationShell.goBranch(pageIndex + 1);
    } else if (pageIndex == 2) {
      context.read<SignUpPresenter>().resetPreferredBeanTaste();
      widget.navigationShell.goBranch(pageIndex + 1);
    } else if (pageIndex == 3) {
      context.go('/login/signup/finish?nickname=${context.read<SignUpPresenter>().nickName}');
    }
  }

  bool get isSkippablePage => widget.navigationShell.currentIndex != 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<SignUpPresenter>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThrottleButton(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: ColorStyles.white,
        appBar: buildAppbar(),
        body: SafeArea(
          child: Selector<SignUpPresenter, bool>(
            selector: (context, presenter) => presenter.isLoading,
            builder: (context, isLoading, child) {
              return AbsorbPointer(
                absorbing: isLoading,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final width = (constraints.maxWidth - 6) / 4;
                                return Row(
                                  spacing: 2,
                                  children: List<Widget>.generate(
                                    4,
                                    (index) => Container(
                                      height: 2,
                                      width: width,
                                      color: index <= widget.navigationShell.currentIndex
                                          ? ColorStyles.red
                                          : ColorStyles.gray40,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 28),
                            Expanded(
                              child: SingleChildScrollView(child: widget.navigationShell),
                            ),
                            Builder(builder: (context) {
                              final isValid = context.select<SignUpPresenter, bool>(
                                (presenter) => presenter.canNext(widget.navigationShell.currentIndex),
                              );
                              return buildNextButton(isSatisfyRequirements: isValid);
                            }),
                          ],
                        ),
                      ),
                    ),
                    if (isLoading) const Positioned.fill(child: LoadingBarrier())
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  AppBar buildAppbar() {
    return AppBar(
      elevation: 0,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      toolbarOpacity: 0,
      title: Container(
        padding: const EdgeInsets.only(top: 28, bottom: 12, left: 16, right: 16),
        height: 64,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              child: ThrottleButton(
                onTap: onPop,
                child: SvgPicture.asset('assets/icons/back.svg', width: 24, height: 24, fit: BoxFit.cover),
              ),
            ),
            Center(
              child: Text(
                '회원가입',
                style: TextStyles.title02SemiBold.copyWith(color: ColorStyles.black),
                textAlign: TextAlign.center,
              ),
            ),
            Positioned(
              right: 0,
              child: FutureButton<void, SignupException>(
                onTap: () => context.read<SignUpPresenter>().onSkip(widget.navigationShell.currentIndex),
                onComplete: (_) {
                  onSkip().call();
                },
                onError: (exception) {
                  if (exception != null) {
                    EventBus.instance.fire(MessageEvent(message: exception.message));
                  }
                },
                child: isSkippablePage
                    ? Text(
                        '건너뛰기',
                        style: TextStyles.labelSmallSemiBold.copyWith(color: ColorStyles.gray50),
                      )
                    : const SizedBox(width: 24, height: 24),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildNextButton({required bool isSatisfyRequirements}) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 24.0),
      child: FutureButton<void, SignupException>(
        onTap: () => context.read<SignUpPresenter>().isValidAt(widget.navigationShell.currentIndex),
        onComplete: (_) {
          onNext.call();
        },
        onError: (exception) {
          if (exception != null) {
            EventBus.instance.fire(MessageEvent(message: exception.message));
          }
        },
        child: Container(
          height: 47,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSatisfyRequirements ? ColorStyles.black : ColorStyles.gray30,
          ),
          child: Center(
            child: Text(
              '다음',
              style: TextStyles.labelMediumMedium.copyWith(
                color: isSatisfyRequirements ? ColorStyles.white : ColorStyles.gray40,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
