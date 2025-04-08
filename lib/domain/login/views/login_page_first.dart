import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/core/show_bottom_sheet.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginPageFirst extends StatefulWidget {
  const LoginPageFirst({super.key});

  @override
  State<LoginPageFirst> createState() => _LoginPageFirstState();
}

class _LoginPageFirstState extends State<LoginPageFirst> {
  final List<String> images = [
    'assets/images/cafe.png',
    'assets/images/coffeeEnjoy.png',
    'assets/images/maker.png',
  ];
  final List<String> titleList = [
    "시음 기록",
    "원두 검색",
    "원두 추천",
  ];
  final List<String> contentList = [
    "오늘 경함한 원두의 맛을 기록해 보세요.",
    "오늘 경험할 원두를 필터로 검색해 보세요.",
    "내 커피 취향에 맞는 원두 추천을 받아보세요.",
  ];
  bool _isDialogShown = false;
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (SharedPreferencesRepository.instance.isFirstTimeLogin && !_isDialogShown) {
        _isDialogShown = true;
        _showPermissionDialog();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 128,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(titleList[_currentIndex], style: TextStyles.title05Bold),
                  const SizedBox(height: 8),
                  Text(contentList[_currentIndex], style: TextStyles.labelMediumMedium),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 240,
                    width: 240,
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (context, _, index) => ExtendedImage.asset(images[index], fit: BoxFit.cover),
                      options: CarouselOptions(
                        aspectRatio: 1,
                        viewportFraction: 1.0,
                        enableInfiniteScroll: false,
                        initialPage: 0,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                      ),
                    ),
                  ),
                  Container(height: 53),
                  Padding(padding: const EdgeInsets.only(top: 8, bottom: 2), child: _buildAnimatedSmoothIndicator()),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      context.push('/login');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: ColorStyles.black),
                      child: Center(
                        child: Text(
                          '로그인/회원가입',
                          style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      AccountRepository.instance.loginWithGuest();
                      context.go('/home?is_guest=true');
                    },
                    child: Container(
                      decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                      child: Text('둘러보기', style: TextStyles.labelSmallMedium),
                    ),
                  ),
                  const SizedBox(height: 46),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedSmoothIndicator() {
    return Center(
      child: AnimatedSmoothIndicator(
        activeIndex: _currentIndex,
        count: images.length, // Replace count
        axisDirection: Axis.horizontal,
        effect: CustomizableEffect(
          dotDecoration: DotDecoration(
            width: 7,
            height: 7,
            color: ColorStyles.gray50,
            borderRadius: BorderRadius.circular(7),
          ),
          activeDotDecoration: const DotDecoration(
            width: 20,
            height: 7,
            color: ColorStyles.red,
            borderRadius: BorderRadius.all(Radius.circular(3.49)),
          ),
          spacing: 4,
        ),
      ),
    );
  }

  _showPermissionDialog() async {
    await showBarrierDialog(
      context: context,
      pageBuilder: (context, _, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 32),
                padding: const EdgeInsets.all(24),
                decoration:
                    const BoxDecoration(color: ColorStyles.white, borderRadius: BorderRadius.all(Radius.circular(8))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DefaultTextStyle(
                      style: TextStyles.title02Bold.copyWith(color: ColorStyles.black, decoration: null),
                      child: const Text('브루버즈를 사용하기 위해 필요한\n접근권한을 안내해 드릴게요.', textAlign: TextAlign.center),
                    ),
                    const SizedBox(height: 32),
                    DefaultTextStyle(
                      style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.black, decoration: null),
                      child: const Text('카메라 (선택)', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 2),
                    DefaultTextStyle(
                      style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                      child: const Text('커피 노트 작성 시 사진 촬영', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 16),
                    DefaultTextStyle(
                      style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.black, decoration: null),
                      child: const Text('사진 권한 (선택)', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 2),
                    DefaultTextStyle(
                      style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                      child: const Text('프로필 설정, 커피 노트 작성 시 사진 첨부', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 16),
                    DefaultTextStyle(
                      style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.black, decoration: null),
                      child: const Text('위치 권한 (선택)', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 2),
                    DefaultTextStyle(
                      style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                      child: const Text('커피 노트 작성 시 장소 검색', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 16),
                    DefaultTextStyle(
                      style: TextStyles.title01SemiBold.copyWith(color: ColorStyles.black, decoration: null),
                      child: const Text('알림 (선택)', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 2),
                    DefaultTextStyle(
                      style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                      child: const Text('좋아요, 댓글 등 반응 및 이벤트 혜택 알림', textAlign: TextAlign.start),
                    ),
                    const SizedBox(height: 16),
                    DefaultTextStyle(
                      style: TextStyles.captionMediumNarrowMedium.copyWith(color: ColorStyles.gray50),
                      child: const Text(
                        '브루버즈는  더 나은 서비스를 제공하기 위해 서비스에 꼭 필요한 기능들에 접근하고 있습니다. 서비스 제공에 접근 권한이 꼭 필요한 경우에만 동의를 받고 있으며, 해당 기능을 허용하지 않으셔도 브루버즈를 이용하실 수 있습니다. ',
                        textAlign: TextAlign.start,
                        maxLines: null,
                      ),
                    ),
                    const SizedBox(height: 26),
                    GestureDetector(
                      onTap: () {
                        context.pop();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
                        decoration: const BoxDecoration(
                          color: ColorStyles.black,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: DefaultTextStyle(
                          style: TextStyles.labelMediumMedium.copyWith(color: ColorStyles.white),
                          child: const Text('확인', textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
    await SharedPreferencesRepository.instance.setLogin();
  }
}
