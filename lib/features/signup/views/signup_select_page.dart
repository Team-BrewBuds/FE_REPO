import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/views/signup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpSelect extends StatefulWidget {
  const SignUpSelect({super.key});

  @override
  State<SignUpSelect> createState() => _SignUpSelectState();
}

class _SignUpSelectState extends State<SignUpSelect> with SignupMixin<SignUpSelect> {
  @override
  int get currentPageIndex => 3;

  @override
  bool get isSatisfyRequirements {
    final presenter = context.read<SignUpPresenter>();
    return presenter.body != null &&
        presenter.acidity != null &&
        presenter.bitterness != null &&
        presenter.sweetness != null;
  }

  @override
  bool get isSkippablePage => true;

  @override
  void Function() get onNext => () {};

  @override
  void Function() get onSkip => () {};

  @override
  Widget buildBody(BuildContext context, SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('평소에 어떤 커피를 즐기세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text('버디님의 커피 취향에 꼭 맞는 원두를 만나보세요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
        const SizedBox(height: 27),
        _buildBodyFeeling(presenter),
        const SizedBox(height: 16),
        _buildAcidity(presenter),
        const SizedBox(height: 16),
        _buildBitterness(presenter),
        const SizedBox(height: 16),
        _buildSweet(presenter),
      ],
    );
  }

  Widget _buildBodyFeeling(SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('바디감', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) => InkWell(
                      onTap: () {
                        presenter.onChangeBodyValue(index);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: presenter.body == index ? ColorStyles.white : Colors.transparent,
                          shape: BoxShape.circle,
                          border: presenter.body == index ? Border.all(color: ColorStyles.red) : null,
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 28,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      if (index == 0) {
                        return Text(
                          '가벼운',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 1) {
                        return Text(
                          '약간 가벼운',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 2) {
                        return Text(
                          '보통',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 3) {
                        return Text(
                          '약간 무거운',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else {
                        return Text(
                          '무거운',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      }
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

  Widget _buildAcidity(SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('산미', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) => InkWell(
                      onTap: () {
                        presenter.onChangeAcidityValue(index);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: presenter.acidity == index ? ColorStyles.white : Colors.transparent,
                          shape: BoxShape.circle,
                          border: presenter.acidity == index ? Border.all(color: ColorStyles.red) : null,
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 28,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      if (index == 0) {
                        return Text(
                          '약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 1) {
                        return Text(
                          '약간 약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 2) {
                        return Text(
                          '보통',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 3) {
                        return Text(
                          '약간 강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else {
                        return Text(
                          '강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      }
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

  Widget _buildBitterness(SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('쓴맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) => InkWell(
                      onTap: () {
                        presenter.onChangeBitternessValue(index);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: presenter.bitterness == index ? ColorStyles.white : Colors.transparent,
                          shape: BoxShape.circle,
                          border: presenter.bitterness == index ? Border.all(color: ColorStyles.red) : null,
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 28,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      if (index == 0) {
                        return Text(
                          '약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 1) {
                        return Text(
                          '약간 약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 2) {
                        return Text(
                          '보통',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 3) {
                        return Text(
                          '약간 강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else {
                        return Text(
                          '강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      }
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

  Widget _buildSweet(SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('단맛', style: TextStyles.title01SemiBold),
        const SizedBox(height: 16),
        SizedBox(
          height: 42,
          child: Stack(
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
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) => InkWell(
                      onTap: () {
                        presenter.onChangeSweetnessValue(index);
                      },
                      child: Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          color: presenter.sweetness == index ? ColorStyles.white : Colors.transparent,
                          shape: BoxShape.circle,
                          border: presenter.sweetness == index ? Border.all(color: ColorStyles.red) : null,
                        ),
                        child: Center(
                          child: Container(
                            height: 14,
                            width: 14,
                            decoration: BoxDecoration(
                              color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 28,
                left: 4,
                right: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    5,
                    (index) {
                      if (index == 0) {
                        return Text(
                          '약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 1) {
                        return Text(
                          '약간 약한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 2) {
                        return Text(
                          '보통',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else if (index == 3) {
                        return Text(
                          '약간 강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      } else {
                        return Text(
                          '강한',
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness == index ? ColorStyles.red : ColorStyles.gray50,
                          ),
                        );
                      }
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
