import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/features/signup/views/signup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CoffeeLifestylePage extends StatefulWidget {
  const CoffeeLifestylePage({super.key});

  @override
  State<CoffeeLifestylePage> createState() => _CoffeeLifestylePageState();
}

class _CoffeeLifestylePageState extends State<CoffeeLifestylePage> with SignupMixin<CoffeeLifestylePage> {
  @override
  int get currentPageIndex => 1;

  @override
  bool get isSatisfyRequirements => context.read<SignUpPresenter>().selectedCoffeeLife.isNotEmpty;

  @override
  bool get isSkippablePage => true;

  @override
  void Function() get onNext => () {
        context.push('/signup/cert');
      };

  @override
  void Function() get onSkip => () {};

  @override
  Widget buildBody(BuildContext context, SignUpPresenter presenter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('커피 생활을 어떻게 즐기세요?', style: TextStyles.title04SemiBold),
        const SizedBox(height: 4),
        Text('최대 6개까지 선택할 수 있어요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
        const SizedBox(height: 14),
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: CoffeeLife.values.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  presenter.onSelectCoffeeLife(CoffeeLife.values[index]);
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
                  decoration: BoxDecoration(
                    color: presenter.selectedCoffeeLife.contains(CoffeeLife.values[index])
                        ? ColorStyles.background
                        : ColorStyles.white,
                    border: Border.all(
                        color: presenter.selectedCoffeeLife.contains(CoffeeLife.values[index])
                            ? ColorStyles.red
                            : ColorStyles.gray50),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Column(
                    children: [
                      const Spacer(),
                      Image.asset(CoffeeLife.values[index].imagePath, width: 120, height: 86, fit: BoxFit.cover),
                      const SizedBox(height: 4),
                      Text(
                        CoffeeLife.values[index].title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 15.6 / 13,
                          letterSpacing: -0.01,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        CoffeeLife.values[index].description,
                        style: TextStyles.captionSmallMedium.copyWith(
                          color: ColorStyles.gray60,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
