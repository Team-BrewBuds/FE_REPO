import 'package:flutter_dotenv/flutter_dotenv.dart';

/*
* api 공통 정의해서 사용하는 파일.
*
* */


class ApiConstants {
  static  String baseUrl = dotenv.env['BASE_URL']!;  //baseUrl
  static const String refreshToken = '/profiles/api/token/refresh/'; // 토큰 재발급
  static const String signup = '/profiles/signup/'; //회원가입
  static String platformLogin(String platform) {
    return '/profiles/login/$platform/finish/';   // sns 로그인 api ,kakao,apple,naver
  }


}