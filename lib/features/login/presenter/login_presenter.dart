import 'dart:developer';

import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/models/login_model.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter {
  final LoginModel model;
  final AuthService authService;

  LoginPresenter(this.model, this.authService);

  Future<bool> loginWithKakao() async {
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

      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();

      if (user.kakaoAccount?.email != null) {
        // 서버로 token, email 정보 전송
        return await AuthService().sendTokenData(user.kakaoAccount!.email!, token.accessToken, 'kakao') ? true : false;
      }
    } catch (e) {
      log(await KakaoSdk.origin);
    }
    return false;
  }

  Future<bool> loginWithNaver() async {
    try {
      // 로그인 시도
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      NaverAccessToken resAccess = await FlutterNaverLogin.currentAccessToken;

      if (res.status == NaverLoginStatus.loggedIn) {
        return await AuthService().sendTokenData(res.account.email, resAccess.accessToken, 'naver') ? true : false;
      } else {
        log('네이버 로그인 실패: ${res.errorMessage}');
      }

      return true;
    } catch (e) {
      log('네이버 로그인 에러: $e');
    }
    return false;
  }

  Future<bool> loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken != null) {
        return await AuthService().sendTokenData('', credential.identityToken!, 'apple') ? true : false;
      }

      return true;
    } catch (e) {
      log('애플 로그인 에러: $e');
    }

    return false;
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