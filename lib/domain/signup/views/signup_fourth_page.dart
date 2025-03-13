import 'package:brew_buds/common/extension/iterator_widget_ext.dart';
import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/domain/signup/core/signup_mixin.dart';
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
  bool get isSkippablePage => false;

  @override
  void Function() get onNext => () async {
    final context = this.context;
    final result = await context.read<SignUpPresenter>().register();
    if (result && context.mounted) {
      final nickname = context.read<SignUpPresenter>().nickName;
      context.push('/signup/finish', extra: nickname);
    }
  };

  @override
  void Function() get onSkip => () {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpPresenter>().resetPreferredBeanTaste();
    });
  }

  @override
  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('평소에 어떤 커피를 즐기세요?', style: TextStyles.title04SemiBold),
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
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
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
                          const SizedBox(height: 6),
                          Text(
                            _body[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: bodyValue != 0 && bodyValue == value
                                  ? ColorStyles.red
                                  : bodyValue == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
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
                          const SizedBox(height: 6),
                          Text(
                            _acidity[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: acidityValue != 0 && acidityValue == value
                                  ? ColorStyles.red
                                  : acidityValue == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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
                    (index) {
                      final value = index + 1;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          InkWell(
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
                          const SizedBox(height: 6),
                          Text(
                            _bitterness[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: bitternessValue != 0 && bitternessValue == value
                                  ? ColorStyles.red
                                  : bitternessValue == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
                      );
                    },
                  ).separator(separatorWidget: const Spacer()).toList(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSweet(int sweetValue) {
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
                    (index) {
                      final value = index + 1;
                      return Column(
                        children: [
                          InkWell(
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
                          const SizedBox(height: 6),
                          Text(
                            _sweet[index],
                            style: TextStyles.captionMediumMedium.copyWith(
                              color: sweetValue != 0 && sweetValue == value
                                  ? ColorStyles.red
                                  : sweetValue == 0
                                      ? ColorStyles.gray50
                                      : Colors.transparent,
                            ),
                          ),
                        ],
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

  @override
  Widget buildBottom() {
    return buildBottomButton(
      isSatisfyRequirements: true,
      title: '가입하기',
    );
  }
}
