import 'package:brew_buds/common/text_styles.dart';
import 'package:brew_buds/di/router.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/signup/provider/SignUpProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../common/color_styles.dart';

class SignupPageFinish extends StatefulWidget {
  SignupPageFinish({super.key});

  @override
  State<SignupPageFinish> createState() => _SignupPageFinishState();
}

class _SignupPageFinishState extends State<SignupPageFinish> {
  SignUpProvider provider = SignUpProvider();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              Consumer<SignUpProvider>(builder: (context, signProvicer, child) {
                return Column(
                  children: [
                    Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Image.asset('assets/images/login/finish.png')),
                    SizedBox(height: 100,),
                    Text('${signProvicer.signUpData.nickname} 님', style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
                    Text('환영합니다.', style: TextStyle(fontSize: 20,fontWeight:FontWeight.w500 )),
                    // SizedBox(height: 10,),
                    Text('지금부터 커피 생활을 쉽게 공유하고', style: TextStyles.textlightRegular,),
                    Text('${signProvicer.signUpData.nickname}님의 커피 취향을 빠르게 알아가세요.',
                    style: TextStyles.textlightRegular,)

                  ],
                );
              })
            ],
          )),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.only(bottom: 46.0, left: 16, right: 16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              child: Text('홈으로 가기'),
              onPressed: () {
                Map<String, dynamic> data = {
                  "body": 4, // 바디감 (1~5)
                  "acidity": 3, // 산미 (1~5)
                  "bitterness": 2, // 쓴맛 (1~5)
                  "sweetness": 5
                };
                context.read<SignUpProvider>().getPreferredBeanTaste(data);
                // context.push('/'); 완료시 home 링크 삽입해야함.
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ));
  }
}




