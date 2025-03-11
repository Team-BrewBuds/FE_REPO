import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/features/login/models/social_login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

typedef SocialLoginResultData = ({String accessToken, String refreshToken, int id});

class LoginPresenter extends ChangeNotifier {
  bool _isLoading = false;
  SocialLoginResultData _socialLoginResultData = (accessToken: '', refreshToken: '', id: 0);
  final AccountRepository _accountRepository;
  final LoginRepository _loginRepository;

  LoginPresenter({
    required AccountRepository accountRepository,
    required LoginRepository loginRepository,
  })  : _accountRepository = accountRepository,
        _loginRepository = loginRepository;

  bool get isLoading => _isLoading;

  SocialLoginResultData get loginResultData => _socialLoginResultData;

  init() {
    _isLoading = false;
    notifyListeners();
  }

  Future<Result<bool>> login(SocialLogin socialLogin) async {
    _isLoading = true;
    notifyListeners();

    final socialToken = await loginWithSNS(socialLogin);

    if (socialToken != null) {
      final result = await _registerToken(socialToken, socialLogin.name);
      if (result != null) {
        final hasAccount = await _checkUser(accessToken: result.accessToken);
        if (hasAccount != null) {
          _socialLoginResultData = result;
          _isLoading = false;
          notifyListeners();
          return Result.success(hasAccount);
        }
      }
    }

    _isLoading = false;
    notifyListeners();
    return Result.error('소셜 로그인에 실패했습니다.');
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

  Future<SocialLoginResultData?> _registerToken(String token, String platform) async {
    try {
      final result = await _loginRepository.registerToken(token, platform);
      return (accessToken: result.accessToken, refreshToken: result.refreshToken, id: result.id);
    } catch (_) {
      return null;
    }
  }

  Future<bool?> _checkUser({required String accessToken}) async {
    try {
      final loginResult = await _loginRepository.login(accessToken: accessToken);
      return loginResult;
    } catch (_) {
      return null;
    }
  }

  Future<Result<String>> saveLoginResults() async {
    if (_socialLoginResultData.accessToken.isNotEmpty &&
        _socialLoginResultData.refreshToken.isNotEmpty &&
        _socialLoginResultData.id != 0) {
      await _accountRepository.saveToken(
        accessToken: _socialLoginResultData.accessToken,
        refreshToken: _socialLoginResultData.refreshToken,
      );
      _accountRepository.saveId(id: _socialLoginResultData.id);
      return Result.success('로그인 성공');
    } else {
      return Result.error('다시 로그인을 시도해 주세요.');
    }
  }
}
