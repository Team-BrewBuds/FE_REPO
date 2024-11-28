import 'package:brew_buds/common/color_styles.dart';
import 'package:brew_buds/common/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignupPageFinish extends StatefulWidget {
  const SignupPageFinish({super.key});

  @override
  State<SignupPageFinish> createState() => _SignupPageFinishState();
}

class _SignupPageFinishState extends State<SignupPageFinish> {
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
                    Image.asset(
                      'assets/images/login/finish.png',
                      width: 247,
                      height: 240,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      '~ 님\n 환영합니다.',
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
                    context.go('/home/all');
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
