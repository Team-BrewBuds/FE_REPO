import 'dart:convert';

import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../../../core/auth_service.dart';
import '../../../di/router.dart';
import '../models/login_model.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter {
  final LoginModel model;
  final AuthService authService;

  LoginPresenter(this.model, this.authService);

  Future<void> loginWithKakao() async {
    try {
      // 카카오톡이 설치되어 있는지 확인
      bool isInstalled = await isKakaoTalkInstalled();
      OAuthToken token;

      if (isInstalled) {
        // 카카오톡으로 로그인
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        // 카카오 계정으로 로그인
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      print('카카오 로그인 성공 ${token.accessToken}');

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      print('사용자 정보: ${user.kakaoAccount?.email}');

      if (user.kakaoAccount?.email != null) {
        // 서버로 token, email 정보 전송
        await AuthService().sendTokenData(user.kakaoAccount!.email!, token.accessToken, 'kakao');

      }
    } catch (e) {
      print(await KakaoSdk.origin);
      print('카카오 로그인 실패 $e');
    }
  }

  Future<void> loginWithNaver() async {
    try {
      // 로그인 시도
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      NaverAccessToken resAccess = await FlutterNaverLogin.currentAccessToken;

      print(resAccess);

      if (res.status == NaverLoginStatus.loggedIn) {
        print('네이버 로그인 성공');
        print('액세스 토큰: ${resAccess.accessToken}');
        // 필요한 사용자 정보 활용
        print('이메일: ${res.account.email}');

        // 서버로 token, email 정보 전송
        await AuthService()
            .sendTokenData(res.account.email, resAccess.accessToken, 'naver');
      } else {
        print('네이버 로그인 실패: ${res.errorMessage}');
      }
    } catch (e) {
      print('네이버 로그인 에러: $e');
    }
  }

  Future<void> loginWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential.identityToken);
    AuthService().sendTokenData('', credential.identityToken!, 'apple');
  }

  void setEmail(String email) {
    model.email = email;
  }

  void setPassword(String password) {
    model.password = password;
  }

  Future<void> login() async {
    if (model.validateCredentials()) {
      try {
        await authService.login(model.email, model.password);
        // 로그인 성공 처리
      } catch (e) {
        // 에러 처리
      }
    } else {
      // 유효성 검사 실패 처리
    }
  }
}
