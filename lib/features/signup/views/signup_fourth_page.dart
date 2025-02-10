import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/core/signup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpFourthPage extends StatefulWidget {
  const SignUpFourthPage({super.key});

  @override
  State<SignUpFourthPage> createState() => _SignUpFourthPageState();
}

class _SignUpFourthPageState extends State<SignUpFourthPage> with SignupMixin<SignUpFourthPage> {
  final List<String> _body = ['가벼운', '약간 가벼운', '보통', '약간 무거운', '무거운'];
  final List<String> _acidity = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _bitterness = ['약한', '약간 약한', '보통', '약간 강한', '강한'];
  final List<String> _sweet = ['약한', '약간 약한', '보통', '약간 강한', '강한'];

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
  void Function() get onNext => () {
        context.push('/signup/finish');
      };

  @override
  void Function() get onSkip => () {
        context.push('/signup/finish');
      };

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
        const SizedBox(height: 32),
        _buildAcidity(presenter),
        const SizedBox(height: 32),
        _buildBitterness(presenter),
        const SizedBox(height: 32),
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
          height: 52,
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
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
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
                        const SizedBox(height: 6),
                        Text(
                          _body[index],
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.body != null && presenter.body == index
                                ? ColorStyles.red
                                : presenter.body == null
                                ? ColorStyles.gray50
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
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
          height: 52,
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
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
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
                        const SizedBox(height: 6),
                        Text(
                          _acidity[index],
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.acidity != null && presenter.acidity == index
                                ? ColorStyles.red
                                : presenter.acidity == null
                                ? ColorStyles.gray50
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
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
          height: 52,
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
                bottom: 0,
                child: Row(
                  children: List<Widget>.generate(
                    5,
                    (index) => Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        InkWell(
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
                        const SizedBox(height: 6),
                        Text(
                          _bitterness[index],
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.bitterness != null && presenter.bitterness == index
                                ? ColorStyles.red
                                : presenter.bitterness == null
                                    ? ColorStyles.gray50
                                    : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ).separator(separatorWidget: const Spacer()).toList(),
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
          height: 52,
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
                    (index) => Column(
                      children: [
                        InkWell(
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
                        const SizedBox(height: 6),
                        Text(
                          _sweet[index],
                          style: TextStyles.captionMediumMedium.copyWith(
                            color: presenter.sweetness != null && presenter.sweetness == index
                                ? ColorStyles.red
                                : presenter.sweetness == null
                                ? ColorStyles.gray50
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  onTappedOutSide() {}
}
