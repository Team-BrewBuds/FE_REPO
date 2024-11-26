import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Future authDio() async {
  var dio = Dio();
  final storage = new FlutterSecureStorage();
  String baseURL = dotenv.get("API_ADDRESS");

  // dio.interceptors.clear();
  // 로그인 후 api  인터셉터 구현
  dio.interceptors.add(InterceptorsWrapper(
      //request
      onRequest: (options, handler) async {
    final accessToken = await storage.read(key: 'auth_token');

    options.baseUrl = baseURL;
    options.headers['Authorization'] = 'Bearer $accessToken';
    return handler.next(options);
  },

      //error
      onError: (error, handler) async {
    //토큰 만료시
    if (error.response?.statusCode == 401) {
      final accessToken = await storage.read(key: 'auth_token');
      final refreshToken = await storage.read(key: 'refresh');

      var refreshDio = Dio();
      refreshDio.interceptors.clear();
      refreshDio.interceptors
          .add(InterceptorsWrapper(onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          await storage.deleteAll();
        }
      }));

      refreshDio.options.baseUrl = baseURL;

      // refresh token 으로 재설정.
      final refreshResponse = await refreshDio.post(
          '/profiles/api/token/refresh/',
          data: {'refresh': refreshToken});
      print(refreshResponse.data);

      final newAccessToken = refreshResponse.data["access"];
      await storage.write(key: 'auth_token', value: newAccessToken);
      error.requestOptions.headers['Authorization'] = 'Bearer $accessToken';

      final cloneRequest = await dio.request(error.requestOptions.path,
          options: Options(
              method: error.requestOptions.method,
              headers: error.requestOptions.headers),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters);
      return handler.resolve(cloneRequest);
    }

    return handler.next(error);
  }));

  return dio;
}
