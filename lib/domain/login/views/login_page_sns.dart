import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/login/models/social_login.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/widgets/terms_of_use_bottom_sheet.dart';
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
                            ThrottleButton(
                              onTap: () async {
                                final loginResult = await _login(context, SocialLogin.kakao);
                                if (context.mounted) {
                                  switch (loginResult) {
                                    case null:
                                      break;
                                    case LoginResult.login:
                                      context.go('/home');
                                      break;
                                    case LoginResult.needSignUp:
                                      final result =
                                          await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                                      if (result && context.mounted) {
                                        final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                        if (saveResult) {
                                          context.push('/login/signup/1');
                                        }
                                      }
                                      break;
                                  }
                                }
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
                            ThrottleButton(
                              onTap: () async {
                                final loginResult = await _login(context, SocialLogin.naver);
                                if (context.mounted) {
                                  switch (loginResult) {
                                    case null:
                                      break;
                                    case LoginResult.login:
                                      context.go('/home');
                                      break;
                                    case LoginResult.needSignUp:
                                      final result =
                                          await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                                      if (result && context.mounted) {
                                        final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                        if (saveResult) {
                                          context.push('/login/signup/1');
                                        }
                                      }
                                      break;
                                  }
                                }
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
                            ThrottleButton(
                              onTap: () async {
                                final loginResult = await _login(context, SocialLogin.apple);
                                if (context.mounted) {
                                  switch (loginResult) {
                                    case null:
                                      break;
                                    case LoginResult.login:
                                      context.go('/home');
                                      break;
                                    case LoginResult.needSignUp:
                                      final result =
                                          await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                                      if (result && context.mounted) {
                                        final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                        if (saveResult) {
                                          context.push('/login/signup/1');
                                        }
                                      }
                                      break;
                                  }
                                }
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

  Future<LoginResult?> _login(BuildContext context, SocialLogin socialLogin) {
    return context.read<LoginPresenter>().login(socialLogin);
  }

  Future<bool?> _checkModal(BuildContext context) async {
    return showModalBottomSheet<bool>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      constraints: const BoxConstraints(maxHeight: 421),
      backgroundColor: ColorStyles.white,
      elevation: 0,
      builder: (BuildContext context) {
        return const TermsOfUseBottomSheet();
      },
    );
  }

  showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: ColorStyles.black.withAlpha(90),
            borderRadius: const BorderRadius.all(Radius.circular(5)),
          ),
          child: Center(
            child: Text(
              message,
              style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.white),
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
    );
  }
}
