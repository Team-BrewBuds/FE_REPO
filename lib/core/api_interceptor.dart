import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart' hide Options;

final class ApiInterceptor extends Interceptor {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

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
      final resp = await dio.post(
        '${dotenv.get('API_ADDRESS')}profiles/api/token/refresh/',
        data: {'refresh': refreshToken},
      );

      // 재발급 받은 AccessToken 등록
      final accessToken = resp.data['access'];
      final newRefreshToken = resp.data['refresh'];

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
