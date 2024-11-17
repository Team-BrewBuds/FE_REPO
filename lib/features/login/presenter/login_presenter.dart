import 'package:brew_buds/data/token/token_repository.dart';
import 'package:brew_buds/features/login/models/login_result.dart';
import 'package:brew_buds/features/login/models/social_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter extends ChangeNotifier {
  bool _isLoading = false;
  final TokenRepository _tokenRepository;

  LoginPresenter({
    required TokenRepository tokenRepository,
  }) : _tokenRepository = tokenRepository;

  bool get isLoading => _isLoading;

  Future<LoginResult> socialLogin(SocialLogin socialLogin) async {
    _isLoading = true;
    notifyListeners();

    final String? token;
    switch (socialLogin) {
      case SocialLogin.kakao:
        token = await _loginWithKakao();
      case SocialLogin.naver:
        token = await _loginWithNaver();
      case SocialLogin.apple:
        token = await _loginWithApple();
    }

    _isLoading = false;
    notifyListeners();

    if (token != null && token.isNotEmpty) {
      _tokenRepository.setOAuthToken(token);
      //회원가입 여부 확인
      return LoginResult.success(false, token);
    } else {
      return LoginResult.error('로그인 실패');
    }
  }

  Future<String?> _loginWithKakao() async {
    try {
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      return token.accessToken;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _loginWithNaver() async {
    try {
      // 로그인 시도
      NaverLoginResult res = await FlutterNaverLogin.logIn();

      if (res.status == NaverLoginStatus.loggedIn) {
        NaverAccessToken resAccess = await FlutterNaverLogin.currentAccessToken;
        return resAccess.accessToken;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<String?> _loginWithApple() async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );

      return credential.identityToken;
    } catch (e) {
      return null;
    }
  }

// 체크로직 구현필요. Api 미구현상태임으로 미구현으로 진행
// Future<void> checkUser() async {}
}
