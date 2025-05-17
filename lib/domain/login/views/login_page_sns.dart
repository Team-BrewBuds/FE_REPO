import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/future_button.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/domain/login/models/social_login.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/widgets/terms_of_use_bottom_sheet.dart';
import 'package:brew_buds/exception/login_exception.dart';
import 'package:brew_buds/model/events/message_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SNSLogin extends StatelessWidget {
  const SNSLogin({super.key});

  @override
  Widget build(BuildContext context) {
    const height = 54.0;
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Selector<LoginPresenter, bool>(
        selector: (context, presenter) => presenter.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointer(
            absorbing: isLoading,
            child: Stack(
              children: [
                Center(child: isLoading ? const CircularProgressIndicator(color: ColorStyles.gray60) : Container()),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('간편로그인으로\n빠르게 가입하세요.', style: TextStyles.title05Bold),
                        const SizedBox(height: 48),
                        Column(
                          children: [
                            FutureButton<LoginResult, LoginException>(
                              onTap: () => context.read<LoginPresenter>().login(SocialLogin.kakao),
                              onComplete: (result) async {
                                switch (result) {
                                  case LoginSuccess():
                                    context.go('/home');
                                    break;
                                  case NeedToSignUp():
                                    final checkResult = await _checkModal(context);
                                    if (checkResult != null && checkResult && context.mounted) {
                                      AccountRepository.instance.saveTokenAndIdInMemory(
                                        id: result.id,
                                        accessToken: result.accessToken,
                                        refreshToken: result.refreshToken,
                                      );
                                      context.push('/login/signup/1');
                                    }
                                    break;
                                }
                              },
                              onError: (exception) {
                                EventBus.instance.fire(
                                  MessageEvent(
                                    message: exception?.message ?? '알 수 없는 오류가 발생했어요.',
                                  ),
                                );
                              },
                              child: Container(
                                height: height, // 버튼 높이 통일
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                    color: const Color(0xFFFEE500), borderRadius: BorderRadius.circular(6)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/kakao.svg', width: 18, height: 18),
                                        const SizedBox(width: 8),
                                        Text(
                                          '카카오로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            height: 22.5 / 15,
                                            color: ColorStyles.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            FutureButton<LoginResult, LoginException>(
                              onTap: () => context.read<LoginPresenter>().login(SocialLogin.naver),
                              onComplete: (result) async {
                                switch (result) {
                                  case LoginSuccess():
                                    context.go('/home');
                                    break;
                                  case NeedToSignUp():
                                    final checkResult = await _checkModal(context);
                                    if (checkResult != null && checkResult && context.mounted) {
                                      AccountRepository.instance.saveTokenAndIdInMemory(
                                        id: result.id,
                                        accessToken: result.accessToken,
                                        refreshToken: result.refreshToken,
                                      );
                                      context.push('/login/signup/1');
                                    }
                                    break;
                                }
                              },
                              onError: (exception) {
                                EventBus.instance.fire(
                                  MessageEvent(
                                    message: exception?.message ?? '알 수 없는 오류가 발생했어요.',
                                  ),
                                );
                              },
                              child: Container(
                                height: height, // 버튼 높이 통일
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF03C75A),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 35),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset('assets/icons/naver.svg', width: 16, height: 16),
                                        const SizedBox(width: 15),
                                        Text(
                                          '네이버로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            height: 22.5 / 15,
                                            color: ColorStyles.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 7),
                            FutureButton<LoginResult, LoginException>(
                              onTap: () => context.read<LoginPresenter>().login(SocialLogin.apple),
                              onComplete: (result) async {
                                switch (result) {
                                  case LoginSuccess():
                                    context.go('/home');
                                    break;
                                  case NeedToSignUp():
                                    final checkResult = await _checkModal(context);
                                    if (checkResult != null && checkResult && context.mounted) {
                                      AccountRepository.instance.saveTokenAndIdInMemory(
                                        id: result.id,
                                        accessToken: result.accessToken,
                                        refreshToken: result.refreshToken,
                                      );
                                      context.push('/login/signup/1');
                                    }
                                    break;
                                }
                              },
                              onError: (exception) {
                                EventBus.instance.fire(
                                  MessageEvent(
                                    message: exception?.message ?? '알 수 없는 오류가 발생했어요.',
                                  ),
                                );
                              },
                              child: Container(
                                height: height, // 버튼 높이 통일
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF000000),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 15),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/apple_logo.svg',
                                          width: 13,
                                          height: 13,
                                          colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Apple로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15.sp,
                                            height: 22.5 / 15,
                                            color: ColorStyles.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 12),
        child: Row(
          children: [
            ThrottleButton(
              onTap: () => context.pop(),
              child: SvgPicture.asset('assets/icons/back.svg', width: 24, height: 24),
            )
          ],
        ),
      ),
      toolbarHeight: 67,
    );
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
