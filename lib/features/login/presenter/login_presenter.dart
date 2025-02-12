import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/result/result.dart';
import 'package:brew_buds/features/login/models/social_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

typedef SocialLoginResultData = ({String accessToken, String refreshToken, bool hasAccount});

class LoginPresenter extends ChangeNotifier {
  bool _isLoading = false;
  final AccountRepository _accountRepository;
  final LoginRepository _loginRepository;

  LoginPresenter({
    required AccountRepository accountRepository,
    required LoginRepository loginRepository,
  })  : _accountRepository = accountRepository,
        _loginRepository = loginRepository;

  bool get isLoading => _isLoading;

  Future<bool?> login(SocialLogin socialLogin) async {
    _isLoading = true;
    notifyListeners();

    final socialToken = await loginWithSNS(socialLogin);

    if (socialToken != null) {
      final result = await _registerToken(socialToken, socialLogin.name);
      if (result) {
        final hasAccount = await _checkUser();
        if (hasAccount != null) {
          return hasAccount;
        }
      }
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> loginWithSNS(SocialLogin socialLogin) async {
    switch (socialLogin) {
      case SocialLogin.kakao:
        return _loginWithKakao();
      case SocialLogin.naver:
        return _loginWithNaver();
      case SocialLogin.apple:
        return _loginWithApple();
    }
  }

  Future<String?> _loginWithKakao() async {
    try {
      final String? token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk().then((value) => value.accessToken, onError: (_) => null);
      } else {
        token = await UserApi.instance.loginWithKakaoAccount().then((value) => value.accessToken, onError: (_) => null);
      }
      return token;
    } catch (e) {
      return null;
    }
  }

  Future<String?> _loginWithNaver() async {
    try {
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

  Future<bool> _registerToken(String token, String platform) {
    return _loginRepository.registerToken(token, platform).then(
          (value) => true,
          onError: (_) => false,
        );
  }

  Future<bool?> _checkUser() async {
    final loginResult = await _loginRepository.login();
    switch (loginResult) {
      case Success<bool>():
        return loginResult.data;
      case Error<bool>():
        return null;
    }
  }

  saveLoginResults() async {
    if (_loginRepository.id != null) {
      _accountRepository.saveId(id: _loginRepository.id!);
    }

    if (_loginRepository.accessToken.isNotEmpty && _loginRepository.refreshToken.isNotEmpty) {
      await _accountRepository.saveToken(
        accessToken: _loginRepository.accessToken,
        refreshToken: _loginRepository.refreshToken,
      );
    }
  }
}
