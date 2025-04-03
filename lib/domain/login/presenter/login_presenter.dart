import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/domain/login/models/social_login.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

enum LoginResult {
  login,
  needSignUp;
}

typedef SocialLoginResultData = ({String accessToken, String refreshToken, int id});

class LoginPresenter extends Presenter {
  bool _isLoading = false;
  SocialLoginResultData _socialLoginResultData = (accessToken: '', refreshToken: '', id: 0);
  final AccountRepository _accountRepository = AccountRepository.instance;
  final LoginRepository _loginRepository = LoginRepository.instance;

  bool get isLoading => _isLoading;

  SocialLoginResultData get loginResultData => _socialLoginResultData;

  Future<LoginResult?> login(SocialLogin socialLogin) async {
    _isLoading = true;
    notifyListeners();

    try {
      final socialToken = await _loginWithSNS(socialLogin);
      if (socialToken != null && socialToken.isNotEmpty) {
        final result = await _registerToken(socialToken, socialLogin.name);
        if (result != null) {
          _socialLoginResultData = result;
          final hasAccount = await _checkUser(accessToken: result.accessToken);
          if (hasAccount != null && hasAccount) {
            await _accountRepository.login(
              id: result.id,
              accessToken: result.accessToken,
              refreshToken: result.refreshToken,
            );
            final registered = await NotificationRepository.instance.registerToken(result.accessToken);
            if (registered) {
              _isLoading = false;
              notifyListeners();
              return LoginResult.login;
            }
          } else {
            _isLoading = false;
            notifyListeners();
            return LoginResult.needSignUp;
          }
        }
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }

    _isLoading = false;
    notifyListeners();
    return null;
  }

  Future<String?> _loginWithSNS(SocialLogin socialLogin) async {
    switch (socialLogin) {
      case SocialLogin.kakao:
        return _loginWithKakao();
      case SocialLogin.naver:
        return _loginWithNaver().timeout(const Duration(seconds: 10), onTimeout: () => null);
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
      final loginResult = await _loginRepository.login(accessToken: accessToken).onError((error, stackTrace) => false);
      return loginResult;
    } catch (_) {
      return null;
    }
  }

  bool saveTokenInMemory() {
    final accessToken = loginResultData.accessToken;
    final refreshToken = loginResultData.refreshToken;
    final id = loginResultData.id;

    if (accessToken.isNotEmpty && refreshToken.isNotEmpty && id != 0) {
      AccountRepository.instance.saveTokenAndIdInMemory(id: id, accessToken: accessToken, refreshToken: refreshToken);
      return true;
    } else {
      return false;
    }
  }
}
