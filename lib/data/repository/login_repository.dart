import 'package:brew_buds/data/api/sign_up_api.dart';
import 'package:brew_buds/data/mapper/sign_up/sign_up_mapper.dart';
import 'package:brew_buds/domain/signup/state/signup_state.dart';
import 'package:dio/dio.dart';
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

  Future<RegisterTokenResultData> registerToken(String token, String platform) async {
    return _signUpApi
        .registerToken(
          socialType: platform,
          data: platform == 'apple' ? {"id_token": token} : {"access_token": token},
        )
        .then((result) => (accessToken: result.accessToken, refreshToken: result.refreshToken, id: result.user.id));
  }

  Future<bool> registerAccount({
    required String accessToken,
    required String refreshToken,
    required SignUpState state,
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

          options.headers.addAll({'Authorization': 'Bearer $accessToken'});

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
              data: {'refresh': refreshToken},
            );

            accessToken = resp.data['access'];

            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $accessToken';

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
        data: state.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Error();
      }
    } on DioException catch (e) {
      rethrow;
    }
  }
}
