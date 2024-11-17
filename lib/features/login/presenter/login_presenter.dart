import 'dart:developer';
import 'package:brew_buds/features/login/models/social_login_token.dart';
import 'package:flutter/foundation.dart';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/models/login_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter extends ChangeNotifier {
  bool _isLoading = false;
  SocialLoginToken? _socialLoginToken;
  final LoginModel model;
  final AuthService authService;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  LoginPresenter({required this.model, required this.authService});

  bool get isLoading => _isLoading;
  SocialLoginToken? get socialLoginToken => _socialLoginToken;

  Future<bool> loginWithKakao(BuildContext context) async {
    try {
      // 카카오톡이 설치되어 있는지 확인
      OAuthToken token;
      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }
      // 사용자 정보 가져오기
      User user = await UserApi.instance.me();
      String ? email = user.kakaoAccount?.email.toString();
      log(email!);

      // provider 토큰및 정보 저장
      final signUpProvider = context.read<SignUpProvider>();
      signUpProvider.setToken(token.accessToken, token.refreshToken, 'kakao');

      //서버에서 사용자 이메일로 회원가입 여부 확인 (기능 개발 필요) 회원있으면 true -> 홈화면이동, 없으면 false -> 회원가입 화면으로 이동
      // bool  result = await checkUser(email,token.accessToken);
      //
      //  return result;

      return authService.sendTokenData(token.accessToken, 'kakao', null);

    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log(await KakaoSdk.origin);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> loginWithNaver(BuildContext context) async {
    try {
      _isLoading = true;
      notifyListeners();
      // 로그인 시도
      NaverLoginResult res = await FlutterNaverLogin.logIn();
      NaverAccessToken resAccess = await FlutterNaverLogin.currentAccessToken;

      if (res.status == NaverLoginStatus.loggedIn) {
        // 로컬에 토큰및 정보 저장
        final signUpProvider = context.read<SignUpProvider>();
        signUpProvider.setToken(resAccess.accessToken, resAccess.refreshToken, 'naver');

        //서버에서 사용자 이메일로 회원가입 여부 확인
        bool  result = await checkUser(res.account.email,resAccess.accessToken.toString());

        return result;
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

  Future<bool> loginWithApple(BuildContext context) async {
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [AppleIDAuthorizationScopes.email],
      );
      if (credential.identityToken != null) {
        String email = AppleIDAuthorizationScopes.email.toString();

        // 로컬에 토큰및 정보 저장
        final signUpProvider = context.read<SignUpProvider>();
        signUpProvider.setToken(credential.identityToken.toString(),'', 'apple');

        //서버에서 사용자 이메일로 회원가입 여부 확인
        bool  result = await checkUser(email,credential.identityToken.toString());

        return result;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      log('애플 로그인 에러: $e');
    }
    _isLoading = false;
    notifyListeners();
  }


  Future<bool> checkUser(String email, String token) async{
    try {
      // authService.sendTokenData(token, token , null);
      final response = await Dio().post(
        'API_ADDRESS',
        data: {'email': email},
      );

      if (response.data['isRegistered']) {
        print("이미 등록된 사용자입니다.");

       return authService.sendTokenData(token, token , null);


      } else {
        print("신규 사용자입니다. 회원가입을 진행합니다.");
        return false;
        // 회원가입 페이지로 이동
      }

    } catch (e) {
      print(e);
    }

    return false;
  }
}
