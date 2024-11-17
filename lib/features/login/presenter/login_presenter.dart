import 'dart:developer';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/models/login_model.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/signup/provider/SignUpProvider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

class LoginPresenter {
  final LoginModel model;
  final AuthService authService;
  FlutterSecureStorage _storage = FlutterSecureStorage();

  LoginPresenter(this.model, this.authService);


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
      log(await KakaoSdk.origin);
    }
    return true;
  }

  Future<bool> loginWithNaver(BuildContext context) async {
    try {
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
      log('네이버 로그인 에러: $e');
    }
    return false;
  }

  Future<bool> loginWithApple(BuildContext context) async {
    try {

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          // AppleIDAuthorizationScopes.fullName,
        ],
      );
      if (credential.identityToken != null) {
        String email = AppleIDAuthorizationScopes.email.toString();

        // 로컬에 토큰및 정보 저장
        final signUpProvider = context.read<SignUpProvider>();
        signUpProvider.setToken(credential.identityToken.toString(),'', 'apple');



        //서버에서 사용자 이메일로 회원가입 여부 확인
        bool  result = await checkUser(email,credential.identityToken.toString());

        return result;





        return true;
        // return await AuthService().sendTokenData(credential.identityToken!, 'apple') ? true : false;
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

/*
 토큰을 왜 회원가입이 되지 않은 상태에서 저장하는지

 소셜 로그인 -> API 호출 -> 토큰 -> 회원가입 API 호출

 소셜 로그인 -> 회원가입 작성 -> API 토큰 발생 -> 회원가입 API 호출
 */