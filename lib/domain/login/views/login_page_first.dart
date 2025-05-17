import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/login/widgets/permission_bottom_sheet.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginPageFirst extends StatefulWidget {
  const LoginPageFirst({super.key});

  @override
  State<LoginPageFirst> createState() => _LoginPageFirstState();
}

class _LoginPageFirstState extends State<LoginPageFirst> {
  final List<String> images = [
    'assets/images/banner/tasted_record.png',
    'assets/images/banner/search.png',
    'assets/images/banner/recommend.png',
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
      if (!SharedPreferencesRepository.instance.isCompletePermission && !_isDialogShown) {
        _isDialogShown = true;
        _showPermissionDialog();
      }
    });

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: (constraints.maxHeight / 2) + (240.h / 2) + 36.h,
                child: Column(
                  spacing: 8.h,
                  children: [
                    Text(titleList[_currentIndex], style: TextStyles.title05Bold),
                    Text(contentList[_currentIndex], style: TextStyles.labelMediumMedium),
                  ],
                ),
              ),
              Center(
                child: SizedBox(
                  height: 260.h,
                  width: 260.w,
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
              ),
              Positioned(
                top: (constraints.maxHeight / 2) + (240.h / 2) + 36.h,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 2),
                  child: _buildAnimatedSmoothIndicator(),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 46.h,
                child: Column(
                  children: [
                    ThrottleButton(
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
                    SizedBox(height: 16.h),
                    ThrottleButton(
                      onTap: () {
                        AccountRepository.instance.loginWithGuest();
                        context.go('/home');
                      },
                      child: Container(
                        decoration: const BoxDecoration(border: Border(bottom: BorderSide())),
                        child: Text('둘러보기', style: TextStyles.labelSmallMedium),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
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

  _showPermissionDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: false,
      barrierColor: ColorStyles.black50,
      transitionDuration: const Duration(milliseconds: 300),
      context: context,
      pageBuilder: (context, _, __) {
        return const PermissionBottomSheet();
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
