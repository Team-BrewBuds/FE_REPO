import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/signup/models/signup_lists.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class LoginPageFirst extends StatefulWidget {
  const LoginPageFirst({super.key});

  @override
  State<LoginPageFirst> createState() => _LoginPageFirstState();
}

class _LoginPageFirstState extends State<LoginPageFirst> {
  int _currentIndex = 0;
  final SignUpLists _lists = SignUpLists();

  @override
  void initState() {
    super.initState();
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
                    _lists.title_data[_currentIndex],
                    style: TextStyles.title05Bold,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _lists.content_data[_currentIndex],
                    style: TextStyles.labelMediumMedium,
                  ),
                  const SizedBox(height: 36),
                  SizedBox(
                    height: 240,
                    width: 240,
                    child: CarouselSlider.builder(
                      itemCount: _lists.images.length,
                      itemBuilder: (context, _, index) {
                        return Image.asset(
                          _lists.images[index],
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
                      context.push("/login/sns");
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
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide())
                      ),
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
        count: _lists.images.length, // Replace count
        axisDirection: Axis.horizontal,
        effect: const ScrollingDotsEffect(
          dotHeight: 6,
          dotWidth: 6,
          strokeWidth: 0,
          activeStrokeWidth: 0,
          spacing: 3,
          dotColor: Color(0x4D000000),
          activeDotColor: ColorStyles.red,
        ),
      ),
    );
  }
}
