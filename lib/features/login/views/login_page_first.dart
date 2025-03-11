import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginPageFirst extends StatefulWidget {
  const LoginPageFirst({super.key});

  @override
  State<LoginPageFirst> createState() => _LoginPageFirstState();
}

class _LoginPageFirstState extends State<LoginPageFirst> {
  int _currentIndex = 0;
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginPresenter>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    titleList[_currentIndex],
                    style: TextStyles.title05Bold,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    contentList[_currentIndex],
                    style: TextStyles.labelMediumMedium,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 240,
                    width: 240,
                    child: CarouselSlider.builder(
                      itemCount: images.length,
                      itemBuilder: (context, _, index) {
                        return ExtendedImage.asset(
                          images[index],
                          fit: BoxFit.cover,
                        );
                      },
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
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 2),
                    child: _buildAnimatedSmoothIndicator(),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 12,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      context.push('/login/sns');
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
                  InkWell(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(border: Border(bottom: BorderSide())),
                      child: const Text(
                        '둘러보기',
                        style: TextStyles.labelSmallMedium,
                      ),
                    ),
                  ),
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
            color: ColorStyles.white,
            borderRadius: BorderRadius.all(Radius.circular(3.49)),
          ),
          spacing: 4,
        ),
      ),
    );
  }
}
