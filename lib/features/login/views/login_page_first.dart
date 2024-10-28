import 'package:brew_buds/features/login/presenter/login_presenter.dart';
import 'package:brew_buds/features/login/views/login_page_sns.dart';
import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';

import '../../../core/auth_service.dart';
import '../models/login_model.dart';

class LoginPageFirst extends StatelessWidget {

  const LoginPageFirst({super.key });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    final loginModel = LoginModel();
    final loginPresenter = LoginPresenter(loginModel, authService);
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading:false
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
                "assets/images/search.png"),
            SizedBox(height: 180,),
            SizedBox(
              width: 343.0,
              height: 50.0,
              child: ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) =>snsLogin(presenter: loginPresenter)));
              },
                child: '로그인/회원가입'.text.size(16).make(),
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)
                )
              ),
              ),
            ),
            TextButton(onPressed: (){
              print('click');
            }, child: Text('둘러보기',style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              decoration: TextDecoration.underline
            ),))
          ],
        ),
      )
    );
  }
}
