import 'package:brew_buds/common/styles/color_styles.dart';
import 'package:brew_buds/common/styles/text_styles.dart';
import 'package:brew_buds/domain/signup/provider/sign_up_presenter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SignupFinishPage extends StatefulWidget {
  const SignupFinishPage({super.key});

  @override
  State<SignupFinishPage> createState() => _SignupFinishPageState();
}

class _SignupFinishPageState extends State<SignupFinishPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/login/finish.png', width: 260, height: 260, fit: BoxFit.cover),
                    const SizedBox(height: 16),
                    Text(
                      '${context.read<SignUpPresenter>().nickName} 님\n 환영합니다.',
                      style: TextStyles.title04SemiBold,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '지금부터 커피 생활을 쉽게 공유하고\n버디님의 커피 취향을 빠르게 알아가세요.',
                      style: TextStyles.bodyRegular.copyWith(color: ColorStyles.gray50),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 46, left: 16, right: 16),
                child: InkWell(
                  onTap: () {
                    context.go('/home');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                    decoration: const BoxDecoration(
                      color: ColorStyles.black,
                      borderRadius: BorderRadius.all(
                        Radius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '홈으로 가기',
                        style: TextStyles.bodyRegular.copyWith(color: ColorStyles.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
