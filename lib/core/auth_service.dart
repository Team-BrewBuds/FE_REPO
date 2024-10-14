import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final Dio _dio = Dio();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final String _baseUrl = 'https://your-api-url.com';

  AuthService() {
    _dio.options.baseUrl = _baseUrl;
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioError error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token might be expired, try to refresh it
          if (await refreshToken()) {
            // Retry the original request
            return handler.resolve(await _retry(error.requestOptions));
          }
        }
        return handler.next(error);
      },
    ));
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        final token = response.data['token'];
        await _storage.write(key: 'auth_token', value: token);
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('Login error: ${e.message}');
      return false;
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
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

  Future<bool> register(String email, String password) async {
    try {
      final response = await _dio.post('/register', data: {
        'email': email,
        'password': password,
      });
      return response.statusCode == 201;
    } on DioError catch (e) {
      print('Registration error: ${e.message}');
      return false;
    }
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final response = await _dio.get('/profile');
      return response.data;
    } on DioError catch (e) {
      print('Get profile error: ${e.message}');
      return null;
    }
  }

  Future<bool> refreshToken() async {
    final refreshToken = await _storage.read(key: 'refresh_token');
    if (refreshToken == null) return false;

    try {
      final response = await _dio.post('/refresh', data: {
        'refresh_token': refreshToken,
      });

      if (response.statusCode == 200) {
        final newToken = response.data['token'];
        await _storage.write(key: 'auth_token', value: newToken);
        return true;
      } else {
        return false;
      }
    } on DioError catch (e) {
      print('Token refresh error: ${e.message}');
      return false;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    return _dio.request<dynamic>(requestOptions.path,
        data: requestOptions.data,
        queryParameters: requestOptions.queryParameters,
        options: options);
  }
}