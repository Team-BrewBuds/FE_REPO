import 'dart:developer';
import 'package:brew_buds/features/login/models/social_login.dart';
import 'package:brew_buds/features/login/models/social_login_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter extends ChangeNotifier {
  bool _isLoading = false;
  SocialLoginToken? _socialLoginToken;

  bool get isLoading => _isLoading;
  SocialLoginToken? get socialLoginToken => _socialLoginToken;

  LoginPresenter();

  Future<void> socialLogin(SocialLogin socialLogin) async {
    switch (socialLogin) {
      case SocialLogin.kakao:
        await _loginWithKakao();
        break;
      case SocialLogin.naver:
        await _loginWithNaver();
        break;
      case SocialLogin.apple:
        await _loginWithApple();
        break;
    }
  }

  Future<void> _loginWithKakao() async {
    try {
      _isLoading = true;
      notifyListeners();
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();

      if (user.kakaoAccount != null) {
        _socialLoginToken = SocialLoginToken.kakao(token.accessToken);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log(await KakaoSdk.origin);
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithNaver() async {
    try {
      _isLoading = true;
      notifyListeners();
      // 로그인 시도
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      NaverAccessToken resAccess = await FlutterNaverLogin.currentAccessToken;

      if (res.status == NaverLoginStatus.loggedIn) {
        _socialLoginToken = SocialLoginToken.naver(resAccess.accessToken);
      } else {
        log('네이버 로그인 실패: ${res.errorMessage}');
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log('네이버 로그인 에러: $e');
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loginWithApple() async {
    try {
      _isLoading = true;
      notifyListeners();
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      if (credential.identityToken != null) {
        _socialLoginToken = SocialLoginToken.apple(credential.identityToken!);
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log('애플 로그인 에러: $e');
    }
    _isLoading = false;
    notifyListeners();
  }
}
