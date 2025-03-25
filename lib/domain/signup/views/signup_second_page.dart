import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/domain/signup/provider/sign_up_presenter.dart';
import 'package:brew_buds/domain/signup/core/signup_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignUpSecondPage extends StatefulWidget {
  const SignUpSecondPage({super.key});

  @override
  State<SignUpSecondPage> createState() => _SignUpSecondPageState();
}

class _SignUpSecondPageState extends State<SignUpSecondPage> with SignupMixin<SignUpSecondPage> {
  @override
  int get currentPageIndex => 1;

  @override
  bool get isSkippablePage => true;

  @override
  void Function() get onNext => () {
        context.push('/signup/third');
      };

  @override
  void Function() get onSkip => () {
        context.push('/signup/third');
      };

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SignUpPresenter>().resetCoffeeLifes();
    });
  }

  @override
  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('커피 생활을 어떻게 즐기세요?', style: TextStyles.title04SemiBold),
          const SizedBox(height: 4),
          Text('최대 6개까지 선택할 수 있어요.', style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50)),
          const SizedBox(height: 14),
          Selector<SignUpPresenter, List<CoffeeLife>>(
            selector: (context, presenter) => presenter.selectedCoffeeLife,
            builder: (context, selectedCoffeeLife, child) => MasonryGridView.count(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: CoffeeLife.values.length,
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              itemBuilder: (context, index) {
                final coffeeLife = CoffeeLife.values[index];
                return GestureDetector(
                  onTap: () {
                    context.read<SignUpPresenter>().onSelectCoffeeLife(coffeeLife);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 4, bottom: 8, left: 16, right: 16),
                    decoration: BoxDecoration(
                      color: selectedCoffeeLife.contains(coffeeLife) ? ColorStyles.background : ColorStyles.white,
                      border: Border.all(
                        color: selectedCoffeeLife.contains(coffeeLife) ? ColorStyles.red : ColorStyles.gray50,
                      ),
                      borderRadius: const BorderRadius.all(Radius.circular(8)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(coffeeLife.imagePath, width: 90, height: 90, fit: BoxFit.cover),
                        const SizedBox(height: 4),
                        Text(
                          coffeeLife.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            height: 15.6 / 13,
                            letterSpacing: -0.01,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          coffeeLife.description,
                          style: TextStyles.captionSmallMedium.copyWith(color: ColorStyles.gray60),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildBottom() {
    return Selector<SignUpPresenter, bool>(
      selector: (context, presenter) => presenter.isValidSecondPage,
      builder: (context, isValidSecondPage, child) => buildBottomButton(isSatisfyRequirements: isValidSecondPage),
    );
  }
}
