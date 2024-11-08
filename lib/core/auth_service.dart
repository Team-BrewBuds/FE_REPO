import 'package:brew_buds/constants/api_constants.dart';
import 'package:brew_buds/core/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;
import 'dart:developer';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  late String auth_token;
  late String refrest_token;

  AuthService() {
    _apiService.dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token might be expired, try to refresh it
            if (await refreshToken()) {
              // Retry the original request
              return handler.resolve(await _retry(error.requestOptions));
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

// Accesstoken 정보 서버로 전송
  Future<bool> sendTokenData(String token, String platform) async {
    try {
      final response = await _apiService.dio.post(
        ApiConstants.platformLogin(platform),
        data: {
          "access_token": token, //카카오, 네이버 토큰.
          "id_token":token // 애플 토큰.
        },
      );

      if (response.statusCode == 200) {

        auth_token = response.data.entries.elementAt(0).value; // token 가져오기
        refrest_token = response.data.entries.elementAt(1).value; // refrest_token 가져오기

        // 서버에서 받은 각 토큰 로컬스토리지에 저장.
        await _storage.write(key: 'auth_token', value: auth_token);
        await _storage.write(key: 'refresh', value: refrest_token);

        log('${_storage.read(key:'auth_token')}');
        return true;

      }
      else {
        log('error');
        return false;
      }
    } on DioException catch (e) {
      log('error message: ${e.response?.data}');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _apiService.dio.post('/login', data: {'email': email, 'password': password});

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log('Login error: ${e.message}');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
    await FlutterNaverLogin.logOutAndDeleteToken(); //네이버 토큰 삭제

    log('(로그아웃) 토큰 삭제 완료');
    // 서버에 로그아웃 요청을 보낼 수도 있습니다.
    // await _dio.post('/logout');
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'auth_token');
    return token != null;
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  Future<bool> register(Map<String, dynamic> data) async {
    try {
      final response = await _apiService.dio.post(ApiConstants.signup, data: data);
      log(response.statusMessage ?? '');
      return response.statusCode == 201;
    } on DioException catch (e) {
      log('Registration error: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await _apiService.dio.get('/profile');
      return response.data;
    } on DioException catch (e) {
      log('Get profile error: ${e.message}');
      return null;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh');
    if (refreshToken == null) return false;

    try {
      final response = await _apiService.dio.post(ApiConstants.refreshToken, data: {
        'refresh': refreshToken,
      });

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await _storage.write(key: 'auth_token', value: newToken);

        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log('Token refresh error: ${e.message}');
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _apiService.dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
