import 'package:brew_buds/data/api/sign_up_api.dart';
import 'package:brew_buds/data/result/result.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final class Token {
  final String access;
  final String refresh;

  const Token({
    required this.access,
    required this.refresh,
  });
}

typedef RegisterTokenResultData = ({String accessToken, String refreshToken, int? id});

class LoginRepository {
  final SignUpApi _signUpApi = SignUpApi();
  String _accessToken = '';
  String _refreshToken = '';

  LoginRepository._();

  static final LoginRepository _instance = LoginRepository._();

  static LoginRepository get instance => _instance;

  factory LoginRepository() => instance;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  Future<Result<bool>> login() {
    return _signUpApi.login(accessToken: 'Bearer $_accessToken').then(
      (result) {
        if (result.response.statusCode == 204) {
          return Result.success(false);
        } else if (result.response.statusCode == 200) {
          return Result.success(true);
        } else {
          return Result.success(false);
        }
      },
      onError: (_) {
        return Result.error('로그인 실패');
      },
    );
  }

  // Accesstoken 정보 서버로 전송 및 JWT 받아서 로컬 스토리지에 저장
  Future<Result<void>> registerToken(String token, String platform) async {
    return _signUpApi
        .registerToken(
      socialType: platform,
      data: platform == 'apple' ? {"id_token": token} : {"access_token": token},
    )
        .then(
      (result) {
        _accessToken = result.accessToken;
        _refreshToken = result.refreshToken;
        return Result.success(null);
      },
      onError: (_) => Result.error('소셜 로그인/가입 실패'),
    );
  }

  Future<Result<(String, String)>> registerAccount(Map<String, dynamic> data) async {
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

          options.headers.addAll({'Authorization': 'Bearer $_accessToken'});

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
              data: {'refresh': _refreshToken},
            );

            _accessToken = resp.data['access'];

            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $_accessToken';

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
        data: data,
      );

      if (response.statusCode == 200) {
        return Result.success((_accessToken, _refreshToken));
      } else {
        return Result.error('Unexpected status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      return Result.error(e.message ?? '');
    }
  }

  Future<void> logout() async {}
}
