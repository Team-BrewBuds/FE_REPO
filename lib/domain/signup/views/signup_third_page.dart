import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/common/widgets/throttle_button.dart';
import 'package:brew_buds/domain/signup/sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SignUpThirdPage extends StatefulWidget {
  const SignUpThirdPage({super.key});

  @override
  State<SignUpThirdPage> createState() => _SignUpThirdPageState();
}

class _SignUpThirdPageState extends State<SignUpThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('커피 관련 자격증이 있으세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text(
          '현재, 취득한 자격증이 있는지 알려주세요.',
          style: TextStyle(
            color: ColorStyles.gray50,
            fontSize: 14.sp,
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
                child: ThrottleButton(
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
                child: ThrottleButton(
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
}
