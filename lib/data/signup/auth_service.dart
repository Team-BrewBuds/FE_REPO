import 'package:brew_buds/constants/api_constants.dart';
import 'package:brew_buds/core/api_interceptor.dart';
import 'package:brew_buds/data/signup/account_result.dart';
import 'package:brew_buds/data/signup/token_result.dart';
import 'package:brew_buds/data/token/token_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;
import 'dart:developer';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio;

  AuthService({required Dio dio}) : _dio = dio;

  factory AuthService.defaultService() {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(ApiInterceptor());
    return AuthService(dio: dio);
  }

  Future<void> register(String token, String platform, Map<String, dynamic> data) async {
    final tokenResult = await registerToken(token, platform);
    if (tokenResult is TokenSuccess) {
      final accountResult = await registerAccount(tokenResult.access, data);
      if (accountResult is AccountSuccess) {
        await TokenRepository.instance.syncToken(
          accessToken: tokenResult.access,
          refreshToken: tokenResult.refresh,
        );
      }
    }
  }

// Accesstoken 정보 서버로 전송 및 JWT 받아서 로컬 스토리지에 저장
  Future<TokenResult> registerToken(String token, String platform) async {
    try {
      final response = await _dio.post(
        ApiConstants.platformLogin(platform),
        data: {
          "access_token": token, //카카오, 네이버 토큰.
          "id_token": token // 애플 토큰.
        },
      );

      if (response.statusCode == 200) {
        return TokenResult.success(response.data.entries.elementAt(0).value, response.data.entries.elementAt(1).value);
      } else {
        log('Unexpected status code: ${response.statusCode}');
        return TokenResult.error('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Registration error: ${e.message}');
      return TokenResult.error(e.message ?? '');
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'access');
    await FlutterNaverLogin.logOutAndDeleteToken(); //네이버 토큰 삭제

    log('(로그아웃) 토큰 삭제 완료');
    // 서버에 로그아웃 요청을 보낼 수도 있습니다.
    // await _dio.post('/logout');
  }

  //회원가입  - Param:  설문 정보, 토큰 값, sns 플랫폼종류
  Future<AccountResult> registerAccount(String accessToken, Map<String, dynamic> data) async {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    try {
      // 토큰 저장 후 회원가입 save.
      final response = await dio.post(
        '/profiles/signup/',
        options: Options(headers: {'Authorization': 'Bearer $accessToken'}),
        data: data,
      );

      if (response.statusCode == 200) {
        return AccountResult.success();
      } else {
        log('Unexpected status code: ${response.statusCode}');
        return AccountResult.error('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('Registration error: ${e.message}');
      return AccountResult.error(e.message ?? '');
    }
  }
}
