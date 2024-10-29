import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:velocity_x/velocity_x.dart';
import '../../../core/auth_service.dart';
import '../models/login_model.dart';

class LoginPageFirst extends StatelessWidget {
  const LoginPageFirst({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(automaticallyImplyLeading: false),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/search.png"),
              SizedBox(
                height: 180,
              ),
              SizedBox(
                width: 343.0,
                height: 50.0,
                child: ElevatedButton(
                  onPressed: () {
                    context.push("/login/sns");
                  },
                  child: '로그인/회원가입'.text.size(16).make(),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              TextButton(
                  onPressed: () {
                    print('click');
                  },
                  child: Text(
                    '둘러보기',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                        decoration: TextDecoration.underline),
                  ))
            ],
          ),
        ));
  }
}
