import 'dart:convert';

import 'package:brew_buds/data/api/sign_up_api.dart';
import 'package:brew_buds/data/dto/social_login_dto.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/domain/signup/model/sign_up_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef RegisterTokenResultData = ({String accessToken, String refreshToken, int id});
typedef SignUpResultData = ({String accessToken, String refreshToken, int id});

class LoginRepository {
  final SignUpApi _signUpApi = SignUpApi();

  LoginRepository._();

  static final LoginRepository _instance = LoginRepository._();

  static LoginRepository get instance => _instance;

  factory LoginRepository() => instance;

  Future<bool> login({required String accessToken}) {
    return _signUpApi.login(accessToken: 'Bearer $accessToken').then(
      (result) {
        if (result.response.statusCode == 204) {
          return false;
        } else if (result.response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      },
    );
  }

  Future<void> checkNickname({required String nickname}) {
    return Future.value();
  }

  Future<RegisterTokenResultData> registerToken(String token, String platform) async {
    final jsonString = await _signUpApi.registerToken(
      socialType: platform,
      data: platform == 'apple' ? {"id_token": token} : {"access_token": token},
    );
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final dto = SocialLoginDTO.fromJson(json);
          return (accessToken: dto.accessToken, refreshToken: dto.refreshToken, id: dto.user.id);
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<void> registerAccount({
    required SignUpModel model,
  }) async {
    final dio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (
          RequestOptions options,
          RequestInterceptorHandler handler,
        ) async {
          if (options.headers['Authorization'] != null) {
            options.headers.remove('Authorization');
          }

          options.headers.addAll({'Authorization': 'Bearer ${AccountRepository.instance.accessTokenInMemory}'});

          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode != 401) {
            return handler.reject(error);
          }

          final refreshDio = Dio();

          // AccessToken 재발급
          try {
            final resp = await refreshDio.post(
              '${dotenv.get('API_ADDRESS')}profiles/api/token/refresh/',
              data: {'refresh': AccountRepository.instance.refreshTokenInMemory},
            );

            final newAccessToken = resp.data['access'];
            final newRefreshToken = resp.data['refresh'];

            AccountRepository.instance.saveTokenAndIdInMemory(
              id: AccountRepository.instance.idInMemory ?? 0,
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );

            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $newAccessToken';

            final response = await dio.fetch(options);

            return handler.resolve(response);
          } catch (e) {
            return handler.reject(error);
          }
        },
      ),
    );

    try {
      final response = await dio.post(
        '/profiles/signup/',
        data: model.toJson(),
      );
      if (response.statusCode != 200) {
        throw Exception();
      }
    } on DioException catch (_) {
      rethrow;
    }
  }
}
