import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/login/models/social_login.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/features/login/widgets/terms_of_use_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SNSLogin extends StatefulWidget {
  const SNSLogin({super.key});

  @override
  State<SNSLogin> createState() => _SNSLoginState();
}

class _SNSLoginState extends State<SNSLogin> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const height = 54.0;
    return Consumer<LoginPresenter>(
      builder: (context, presenter, _) {
        return Scaffold(
          appBar: _buildAppBar(presenter),
          body: AbsorbPointer(
            absorbing: presenter.isLoading,
            child: Stack(
              children: [
                Center(
                  child: presenter.isLoading ? const CircularProgressIndicator(color: ColorStyles.gray60) : Container(),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '간편로그인으로\n빠르게 가입하세요.',
                          style: TextStyles.title05Bold,
                        ),
                        const SizedBox(height: 48),
                        Column(
                          children: [
                            InkWell(
                              onTap: () {
                                _checkModal(presenter, SocialLogin.kakao);
                              },
                              child: Container(
                                height: height, // 버튼 높이 통일
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFE812),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/kakao.svg',
                                          width: 18,
                                          height: 18,
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          '카카오로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
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
                            InkWell(
                              onTap: () {
                                _checkModal(presenter, SocialLogin.naver);
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
                                        SvgPicture.asset(
                                          'assets/icons/naver.svg',
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 15),
                                        const Text(
                                          '네이버로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
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
                            InkWell(
                              onTap: () {
                                _checkModal(presenter, SocialLogin.kakao);
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
                                        const Text(
                                          'Apple로 로그인',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 15,
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
          ),
        );
      },
    );
  }

  AppBar _buildAppBar(LoginPresenter presenter) {
    return AppBar(
      leading: const SizedBox.shrink(),
      leadingWidth: 0,
      titleSpacing: 0,
      title: Padding(
        padding: const EdgeInsets.only(top: 35, left: 16, right: 16, bottom: 12),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                context.pop();
              },
              child: SvgPicture.asset(
                'assets/icons/back.svg',
                width: 24,
                height: 24,
              ),
            )
          ],
        ),
      ),
      toolbarHeight: 67,
    );
  }

  void _checkModal(LoginPresenter presenter, SocialLogin socialLogin) async {
    final agreeToTerms = await showModalBottomSheet(
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

    if (agreeToTerms != null && agreeToTerms) {
      final result = await presenter.login(socialLogin);
      if (result != null) {
        if (result) {
          await presenter.saveLoginResults();
        } else {
          context.push('/signup');
        }
      }
    }
  }
}
