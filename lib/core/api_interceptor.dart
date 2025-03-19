import 'dart:convert';

import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class ApiInterceptor extends Interceptor {
  ApiInterceptor();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // 보내려는 요청의 헤더
    if (options.headers['Authorization'] != null) {
      // 헤더 삭제
      options.headers.remove('Authorization');
    }

    final token = AccountRepository.instance.accessToken;

    if (token.isNotEmpty) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }

    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.reject(err);
    }

    final refreshToken = AccountRepository.instance.refreshToken;

    if (refreshToken.isEmpty) {
      return handler.reject(err);
    }

    final dio = Dio();

    // AccessToken 재발급
    try {
      final resp = await dio.post<String>(
        '${dotenv.get('API_ADDRESS')}profiles/api/token/refresh/',
        data: {'refresh': refreshToken},
      );
      final result = jsonDecode(resp.data ?? '') as Map<String, dynamic>;
      final accessToken = result['access'] as String;
      final newRefreshToken = result['refresh'] as String;

      await AccountRepository.instance.saveToken(accessToken: accessToken, refreshToken: newRefreshToken);

      final options = err.requestOptions;

      if (options.headers['Authorization'] != null) {
        options.headers.remove('Authorization');
      }
      options.headers.addAll({'Authorization': 'Bearer $accessToken'});

      final response = await dio.fetch(options);

      return handler.resolve(response);
    } catch (e) {
      return handler.reject(err);
    }
  }
}
