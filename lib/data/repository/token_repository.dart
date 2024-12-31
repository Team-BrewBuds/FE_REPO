import 'package:brew_buds/features/login/models/social_login_token.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _accessToken = '';
  String _refreshToken = '';
  SocialLoginToken? _socialToken;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  SocialLoginToken? get socialToken => _socialToken;

  TokenRepository._() {
    _init();
  }

  static final TokenRepository _instance = TokenRepository._();

  static TokenRepository get instance => _instance;

  factory TokenRepository() => instance;

  _init() async {
    _accessToken = await _storage.read(key: 'access') ?? '';
    _refreshToken = await _storage.read(key: 'refresh') ?? '';
    notifyListeners();
  }

  Future<void> syncToken({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _storage.write(key: 'access', value: accessToken);
      _accessToken = accessToken;
      notifyListeners();
    }

    if (refreshToken != null) {
      await _storage.write(key: 'refresh', value: refreshToken);
      _refreshToken = refreshToken;
      notifyListeners();
    }
  }

  setOAuthToken(SocialLoginToken token) {
    _socialToken = token;
  }
}
