import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef RequestState = ({RequestOptions options, ErrorInterceptorHandler handler});

final class ApiInterceptor extends Interceptor {
  ApiInterceptor();

  bool _isRefreshing = false;
  final List<RequestState> _pendingRequests = [];

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AccountRepository.instance.accessToken;

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      print(token);
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.reject(err);
    }

    _pendingRequests.add((options: err.requestOptions, handler: handler));
    if (_isRefreshing) {
      return;
    } else {
      _isRefreshing = true;
    }

    final bool newTokenAvailable = await _refresh().onError((error, stackTrace) => false);
    if (newTokenAvailable) {
      final dio = Dio();
      final accessToken = AccountRepository.instance.accessToken;
      for (final request in _pendingRequests) {
        final currentOptions = request.options;
        final currentHandler = request.handler;
        currentOptions.headers['Authorization'] = 'Bearer $accessToken';
        await dio.fetch(currentOptions).then((response) {
          currentHandler.resolve(response);
        }, onError: (e) => handler.reject(e));
      }
    } else {
      for (final request in _pendingRequests) {
        request.handler.reject(err);
      }
      //로그아웃 처리로직 구현 필요.
    }
    _pendingRequests.clear();
    _isRefreshing = false;
  }

  Future<bool> _refresh() async {
    try {
      final refreshToken = AccountRepository.instance.refreshToken;

      if (refreshToken.isEmpty) {
        return false;
      }

      final refreshDio = Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS')));
      final resp = await refreshDio.post(
        '/profiles/api/token/refresh/',
        data: {'refresh': refreshToken},
      );

      final newAccessToken = resp.data['access'];
      final newRefreshToken = resp.data['refresh'];

      print(newAccessToken);

      await AccountRepository.instance.saveToken(accessToken: newAccessToken, refreshToken: newRefreshToken);

      return true;
    } catch (e) {
      return false;
    }
  }
}
