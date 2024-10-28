import 'package:flutter/material.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../presenter/login_presenter.dart';

class snsLogin extends StatelessWidget {

  final LoginPresenter presenter;

  const snsLogin({super.key, required this.presenter});

  @override
  Widget build(BuildContext context) {
    final height = 55.0;
    final width = 353.0;
    return Scaffold(
      appBar: AppBar(

      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('간편로그인으로\n빠르게 가입하세요.',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 30,),

            Column(
              children: [
                SizedBox(
                  width: width, // 버튼 가로 크기 통일
                  height: height, // 버튼 높이 통일
                  child: ElevatedButton(
                    onPressed: () {
                      presenter.loginWithKakao(); // Kakao 로그인 로직
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFFE812), // Kakao 배경 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login/k.png',
                          // height: height, width: width,
                        ),
                        Text(
                          '카카오로 로그인',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,

                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                SizedBox(
                  width: width, // 버튼 가로 크기 통일
                  height: height, // 버튼 높이 통일
                  child: ElevatedButton(
                    onPressed: () {
                      presenter.loginWithNaver();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF03C75A), // 배경 색상
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/login/naver_btn.png',
                          // height: height, width: width,
                        ),
                        Text('네이버로 로그인', style: TextStyle(
                          color: Colors.white,fontSize: 22
                        ),),
                        SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 10,),
                SignInWithAppleButton(
                    onPressed: presenter.loginWithApple,
                    style: SignInWithAppleButtonStyle.black,
                    text: 'Apple로 로그인',
                    height: height)

              ],
            )

          ],
        ),
      ),
    );
  }
}
