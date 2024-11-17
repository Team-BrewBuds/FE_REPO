import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _accessToken = '';
  String _refreshToken = '';
  String _socialToken = '';

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  String get socialToken => _socialToken;

  TokenRepository._() {
    _init();
  }

  static final TokenRepository _instance = TokenRepository._();

  static TokenRepository get instance => _instance;

  factory TokenRepository() => instance;

  _init() async {
    _accessToken = await _storage.read(key: 'auth_token') ?? '';
    _refreshToken = await _storage.read(key: 'refresh') ?? '';
    notifyListeners();
  }

  syncToken({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _storage.write(key: 'auth_token', value: accessToken);
      notifyListeners();
    }

    if (refreshToken != null) {
      await _storage.write(key: 'refresh', value: refreshToken);
      notifyListeners();
    }
  }

  setOAuthToken(String token) {
    _socialToken = token;
  }

  //토큰 갱신 작업 구현
  fetchRefreshToken() {}
}
