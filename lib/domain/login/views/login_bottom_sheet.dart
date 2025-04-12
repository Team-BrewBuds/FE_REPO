import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/loading_barrier.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/login/models/social_login.dart';
import 'package:brew_buds/domain/login/presenter/login_presenter.dart';
import 'package:brew_buds/domain/login/widgets/terms_of_use_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class LoginBottomSheet extends StatelessWidget {
  const LoginBottomSheet._();

  static Widget buildWithPresenter() => ChangeNotifierProvider(
        create: (_) => LoginPresenter(),
        child: const LoginBottomSheet._(),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          right: 0,
          left: 0,
          bottom: 0,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: ColorStyles.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: SafeArea(
                top: false,
                child: Wrap(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 24, bottom: 16),
                      child: Row(
                        children: [
                          const Spacer(),
                          ThrottleButton(
                            onTap: () {
                              context.pop();
                            },
                            child: SvgPicture.asset(
                              'assets/icons/x.svg',
                              width: 24,
                              height: 24,
                            ),
                          )
                        ],
                      ),
                    ),
                    Center(
                      child: Text(
                        '로그인 / 회원가입하고\n내 커피 취향을 만나보세요!',
                        style: TextStyles.title02Bold,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 24, width: double.infinity),
                    ThrottleButton(
                      onTap: () async {
                        final loginResult = await _login(context, SocialLogin.kakao);
                        if (context.mounted) {
                          switch (loginResult) {
                            case null:
                              context.pop(false);
                              break;
                            case LoginResult.login:
                              context.pop(true);
                              break;
                            case LoginResult.needSignUp:
                              final result =
                                  await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                              if (result && context.mounted) {
                                final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                if (saveResult) {
                                  context.go('/login/signup/1');
                                }
                              }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE500),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/kakao.svg', width: 18, height: 18),
                                const SizedBox(width: 8),
                                Text(
                                  '카카오로 로그인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    height: 1.5,
                                    color: ColorStyles.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7, width: double.infinity),
                    ThrottleButton(
                      onTap: () async {
                        final loginResult = await _login(context, SocialLogin.naver);
                        if (context.mounted) {
                          switch (loginResult) {
                            case null:
                              context.pop(false);
                            case LoginResult.login:
                              context.pop(true);
                            case LoginResult.needSignUp:
                              final result =
                              await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                              if (result && context.mounted) {
                                final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                if (saveResult) {
                                  context.go('/login/signup/1');
                                }
                              }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF03C75A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('assets/icons/naver.svg', width: 18, height: 18),
                                const SizedBox(width: 8),
                                Text(
                                  '네이버로 로그인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    height: 1.5,
                                    color: ColorStyles.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 7, width: double.infinity),
                    ThrottleButton(
                      onTap: () async {
                        final loginResult = await _login(context, SocialLogin.apple);
                        if (context.mounted) {
                          switch (loginResult) {
                            case null:
                              context.pop(false);
                            case LoginResult.login:
                              context.pop(true);
                            case LoginResult.needSignUp:
                              final result =
                              await _checkModal(context).then((value) => value ?? false).onError((_, __) => false);
                              if (result && context.mounted) {
                                final saveResult = context.read<LoginPresenter>().saveTokenInMemory();
                                if (saveResult) {
                                  context.go('/login/signup/1');
                                }
                              }
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/apple_logo.svg',
                                  width: 18,
                                  height: 18,
                                  colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Apple로 로그인',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.sp,
                                    height: 1.5,
                                    color: ColorStyles.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 80.h, width: double.infinity),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (context.select<LoginPresenter, bool>((presenter) => presenter.isLoading))
          const LoadingBarrier(hasOpacity: false),
      ],
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
            color: ColorStyles.black90,
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
