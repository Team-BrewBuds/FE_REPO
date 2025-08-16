import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/domain/login/models/social_login.dart';
import 'package:brew_buds/exception/login_exception.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_naver_login/interface/types/naver_login_result.dart';
import 'package:flutter_naver_login/interface/types/naver_login_status.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

sealed class LoginResult {
  factory LoginResult.login() = LoginSuccess;

  factory LoginResult.needToSignUp({
    required String accessToken,
    required String refreshToken,
    required int id,
  }) = NeedToSignUp;
}

final class LoginSuccess implements LoginResult {}

final class NeedToSignUp implements LoginResult {
  final String accessToken;
  final String refreshToken;
  final int id;

  const NeedToSignUp({
    required this.accessToken,
    required this.refreshToken,
    required this.id,
  });
}

typedef SocialLoginResultData = ({String accessToken, String refreshToken, int id});

class LoginPresenter extends Presenter {
  bool _isLoading = false;
  final AccountRepository _accountRepository = AccountRepository.instance;
  final LoginRepository _loginRepository = LoginRepository.instance;

  bool get isLoading => _isLoading;

  Future<LoginResult> login(SocialLogin socialLogin) async {
    _isLoading = true;
    notifyListeners();

    try {
      final socialToken = await _loginWithSNS(socialLogin);
      final result = await _registerToken(socialToken, socialLogin.name);
      final hasAccount = await _checkUser(accessToken: result.accessToken);
      if (hasAccount) {
        await _accountRepository.login(
          id: result.id,
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
        );
        return LoginResult.login();
      } else {
        return LoginResult.needToSignUp(
          accessToken: result.accessToken,
          refreshToken: result.refreshToken,
          id: result.id,
        );
      }
    } catch (_) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> _loginWithSNS(SocialLogin socialLogin) async {
    final String? token;
    switch (socialLogin) {
      case SocialLogin.kakao:
        token = await _loginWithKakao();
      case SocialLogin.naver:
        token = await _loginWithNaver().timeout(const Duration(seconds: 10), onTimeout: () => null);
      case SocialLogin.apple:
        token = await _loginWithApple();
    }

    if (token != null && token.isNotEmpty) {
      return token;
    } else {
      throw SocialLoginFailedException();
    }
  }

  Future<String?> _loginWithKakao() async {
    print(await KakaoSdk.origin);
    try {
      final String? token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk().then((value) => value.accessToken);
      } else {
        token = await UserApi.instance.loginWithKakaoAccount().then((value) => value.accessToken);
        print(token);
      }
      return token;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> _loginWithNaver() async {
    try {
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      print(res.accessToken);
      print(await FlutterNaverLogin.getCurrentAccessToken().then((token) => token.accessToken));
      print(res.errorMessage);
      if (res.status == NaverLoginStatus.loggedIn) {
        return res.accessToken?.accessToken ?? await FlutterNaverLogin.getCurrentAccessToken().then((token) => token.accessToken);
      } else {
        print('here?');
        return null;
      }
    } catch (e) {
      print('Error $e');
      return null;
    }
  }

  Future<String?> _loginWithApple() async {
    try {
      return await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      ).then((result) => result.identityToken);
    } catch (e) {
      return null;
    }
  }

  Future<SocialLoginResultData> _registerToken(String token, String platform) async {
    try {
      final result = await _loginRepository.registerToken(token, platform);
      return (accessToken: result.accessToken, refreshToken: result.refreshToken, id: result.id);
    } catch (_) {
      throw SocialLoginRegistrationException();
    }
  }

  Future<bool> _checkUser({required String accessToken}) async {
    try {
      return await _loginRepository.login(accessToken: accessToken);
    } catch (_) {
      throw SocialLoginApiException();
    }
  }
}
