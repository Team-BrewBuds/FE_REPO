import 'dart:math';

import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/signup/sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpFourthPage extends StatefulWidget {
  const SignUpFourthPage({super.key});

  @override
  State<SignUpFourthPage> createState() => _SignUpFourthPageState();
}

class _SignUpFourthPageState extends State<SignUpFourthPage> {
  final List<String> _body = ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'];
  final List<String> _acidity = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _bitterness = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _sweet = ['약한', '약간 약한', '보통', '약간 강한', '강한'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('평소에 어떤 커피를 즐기세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text('버디님의 커피 취향에 꼭 맞는 원두를 만나보세요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
        const SizedBox(height: 27),
        Selector<SignUpPresenter, int>(
          selector: (context, presenter) => presenter.body,
          builder: (context, value, child) => _buildBodyFeeling(value),
        ),
        const SizedBox(height: 32),
        Selector<SignUpPresenter, int>(
          selector: (context, presenter) => presenter.acidity,
          builder: (context, value, child) => _buildAcidity(value),
        ),
        const SizedBox(height: 32),
        Selector<SignUpPresenter, int>(
          selector: (context, presenter) => presenter.bitterness,
          builder: (context, value, child) => _buildBitterness(value),
        ),
        const SizedBox(height: 32),
        Selector<SignUpPresenter, int>(
          selector: (context, presenter) => presenter.sweetness,
          builder: (context, value, child) => _buildSweet(value),
        ),
      ],
    );
  }

  Widget _buildBodyFeeling(int bodyValue) {
    final height = max(52, 52.h).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('바디감', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<SignUpPresenter>().onChangeBodyValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: bodyValue == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: bodyValue == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: bodyValue == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _body[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: bodyValue != 0 && bodyValue == value
                                      ? ColorStyles.red
                                      : bodyValue == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAcidity(int acidityValue) {
    final height = max(52, 52.h).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('산미', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<SignUpPresenter>().onChangeAcidityValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: acidityValue == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: acidityValue == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: acidityValue == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _acidity[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: acidityValue != 0 && acidityValue == value
                                      ? ColorStyles.red
                                      : acidityValue == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBitterness(int bitternessValue) {
    final height = max(52, 52.h).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('쓴맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<SignUpPresenter>().onChangeBitternessValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: bitternessValue == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: bitternessValue == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: bitternessValue == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _bitterness[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: bitternessValue != 0 && bitternessValue == value
                                      ? ColorStyles.red
                                      : bitternessValue == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSweet(int sweetValue) {
    final height = max(52, 52.h).toDouble();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('단맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          height: height,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 14,
                left: 10,
                right: 10,
                child: Container(
                  height: 1,
                  color: const Color(0xFFCFCFCF),
                ),
              ),
              Positioned.fill(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      final value = index + 1;
                      return SizedBox(
                        width: 28,
                        height: height,
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 0,
                              child: ThrottleButton(
                                onTap: () {
                                  context.read<SignUpPresenter>().onChangeSweetnessValue(value);
                                },
                                child: Container(
                                  height: 28,
                                  width: 28,
                                  decoration: BoxDecoration(
                                    color: sweetValue == value ? ColorStyles.white : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: sweetValue == value ? Border.all(color: ColorStyles.red) : null,
                                  ),
                                  child: Center(
                                    child: Container(
                                      height: 14,
                                      width: 14,
                                      decoration: BoxDecoration(
                                        color: sweetValue == value ? ColorStyles.red : ColorStyles.gray50,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              child: Text(
                                _sweet[index],
                                style: TextStyles.captionMediumMedium.copyWith(
                                  color: sweetValue != 0 && sweetValue == value
                                      ? ColorStyles.red
                                      : sweetValue == 0
                                          ? ColorStyles.gray50
                                          : Colors.transparent,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
