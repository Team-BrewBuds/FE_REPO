import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/core/signup_mixin.dart';
import 'package:brew_buds/features/signup/views/signup_fourth_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpThirdPage extends StatefulWidget {
  const SignUpThirdPage({super.key});

  @override
  State<SignUpThirdPage> createState() => _SignUpThirdPageState();
}

class _SignUpThirdPageState extends State<SignUpThirdPage> with SignupMixin<SignUpThirdPage> {
  @override
  int get currentPageIndex => 2;

  @override
  bool get isSkippablePage => true;

  @override
  void Function() get onNext => () {
        context.push('/signup/fourth');
      };

  @override
  void Function() get onSkip => () {
        context.push('/signup/fourth');
      };

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpPresenter>().resetCertificated();
    });
  }

  @override
  Widget buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('커피 관련 자격증이 있으세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        const Text(
          '현재, 취득한 자격증이 있는지 알려주세요.',
          style: TextStyle(
            color: ColorStyles.gray50,
            fontSize: 14,
            fontWeight: FontWeight.w400,
            height: 21 / 14,
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(height: 22),
        Selector<SignUpPresenter, bool?>(
          selector: (context, presenter) => presenter.isCertificated,
          builder: (context, isCertificated, child) => Row(
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<SignUpPresenter>().onChangeCertificate(true);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isCertificated ?? false ? ColorStyles.background : ColorStyles.white,
                      border: Border.all(color: isCertificated ?? false ? ColorStyles.red : ColorStyles.gray50),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '있어요',
                        style: TextStyles.labelMediumMedium.copyWith(
                          color: isCertificated ?? false ? ColorStyles.red : ColorStyles.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: InkWell(
                  onTap: () {
                    context.read<SignUpPresenter>().onChangeCertificate(false);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: BoxDecoration(
                      color: isCertificated ?? true ? ColorStyles.white : ColorStyles.background,
                      border: Border.all(color: isCertificated ?? true ? ColorStyles.gray50 : ColorStyles.red),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '없어요',
                        style: TextStyles.labelMediumMedium.copyWith(
                          color: isCertificated ?? true ? ColorStyles.black : ColorStyles.red,
                        ),
                      ),
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
  Widget buildBottom() {
    return Selector<SignUpPresenter, bool>(
      selector: (context, presenter) => presenter.isValidThirdPage,
      builder: (context, isValidThirdPage, child) => buildBottomButton(isSatisfyRequirements: isValidThirdPage),
    );
  }
}
