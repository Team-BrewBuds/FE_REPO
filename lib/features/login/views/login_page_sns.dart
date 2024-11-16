import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<LoginPresenter>(builder: (context, presenter, _) {
        return AbsorbPointer(
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
                          SizedBox(
                            height: height, // 버튼 높이 통일
                            child: ElevatedButton(
                              onPressed: () {
                                _checkModal(presenter, SocialLogin.kakao); // Kakao 로그인 로직
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFE812), // Kakao 배경 색상
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/kakao.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '카카오로 로그인',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      height: 22.5 / 15,
                                      color: ColorStyles.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: height, // 버튼 높이 통일
                            child: ElevatedButton(
                              onPressed: () {
                                _checkModal(presenter, SocialLogin.naver);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF03C75A), // 배경 색상
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/naver.svg',
                                    width: 16,
                                    height: 16,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    '네이버로 로그인',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      height: 22.5 / 15,
                                      color: ColorStyles.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 7),
                          SizedBox(
                            height: height, // 버튼 높이 통일
                            child: ElevatedButton(
                              onPressed: () {
                                _checkModal(presenter, SocialLogin.apple);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF000000), // 배경 색상
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/apple_logo.svg',
                                    width: 16,
                                    height: 16,
                                    colorFilter: const ColorFilter.mode(ColorStyles.white, BlendMode.srcIn),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Apple로 로그인',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                      height: 22.5 / 15,
                                      color: ColorStyles.white,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _checkModal(LoginPresenter presenter, SocialLogin socialLogin) async {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)),
      ),
      constraints: const BoxConstraints(maxHeight: 421, minHeight: 421),
      backgroundColor: ColorStyles.white,
      elevation: 0,
      builder: (BuildContext context) {
        return const TermsOfUseBottomSheet();
      },
    ).then((result) {
      if (result != null && result) {
        presenter.socialLogin(socialLogin).whenComplete(() {
          if(presenter.socialLoginToken != null) {
            context.push('/signup');
          }
        });
      }
    });
  }
}
