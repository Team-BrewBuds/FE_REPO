import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/model/events/need_login_event.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef RequestState = ({RequestOptions options, ErrorInterceptorHandler handler});

final class ApiInterceptor extends Interceptor {
  ApiInterceptor();

  Completer<bool>? _refreshCompleter;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = AccountRepository.instance.accessToken;

    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.reject(err);
    }

    var completer = _refreshCompleter;

    if (completer != null) {
      if (await completer.future) {
        _retryRequest(err.requestOptions, AccountRepository.instance.accessToken, handler);
      } else {
        handler.reject(err);
        EventBus.instance.fire(NeedLoginEvent());
      }
    } else {
      _refreshCompleter = Completer<bool>();
      final bool newTokenAvailable = await _refresh().onError((error, stackTrace) => false);
      _refreshCompleter?.complete(newTokenAvailable);
      if (newTokenAvailable) {
        _retryRequest(err.requestOptions, AccountRepository.instance.accessToken, handler);
      } else {
        handler.reject(err);
        EventBus.instance.fire(NeedLoginEvent());
      }
      _refreshCompleter = null;
    }
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

      await AccountRepository.instance.saveToken(accessToken: newAccessToken, refreshToken: newRefreshToken);

      return true;
    } on DioException catch (_) {
      return false;
    }
  }

  void _retryRequest(RequestOptions options, String accessToken, ErrorInterceptorHandler handler) async {
    final dio = Dio();
    final currentOptions = options;
    currentOptions.headers['Authorization'] = 'Bearer $accessToken';
    try {
      final response = await dio.fetch(currentOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.reject(e);
    }
  }
}
