import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isGuest = false;
  String _refreshToken = '';
  String _accessToken = '';
  int? _id;
  String _refreshTokenInMemory = '';
  String _accessTokenInMemory = '';
  int? _idInMemory;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  int? get id => _id;

  String get accessTokenInMemory => _accessTokenInMemory;

  String get refreshTokenInMemory => _refreshTokenInMemory;

  int? get idInMemory => _idInMemory;

  bool get isGuest => _isGuest;

  AccountRepository._();

  static final AccountRepository _instance = AccountRepository._();

  static AccountRepository get instance => _instance;

  factory AccountRepository() => instance;

  Future<void> init() async {
    _accessToken = await _storage.read(key: 'access') ?? '';
    _refreshToken = await _storage.read(key: 'refresh') ?? '';
    _id = int.tryParse(await _storage.read(key: 'id') ?? '');
  }

  saveTokenAndIdInMemory({required int id, required String accessToken, required String refreshToken}) {
    _refreshTokenInMemory = refreshToken;
    _accessTokenInMemory = accessToken;
    _idInMemory = id;
  }

  Future<void> saveToken({String? accessToken, String? refreshToken}) async {
    if (accessToken != null) {
      await _storage.write(key: 'access', value: accessToken);
      _accessToken = accessToken;
    }

    if (refreshToken != null) {
      await _storage.write(key: 'refresh', value: refreshToken);
      _refreshToken = refreshToken;
    }
  }

  Future<void> saveId({required int id}) async {
    await _storage.write(key: 'id', value: '$id');
    _id = id;
  }

  Future<void> logout({bool forceLogout = false}) async {
    await _storage.deleteAll();
    _isGuest = false;
    _id = null;
    _accessToken = '';
    _refreshToken = '';
  }

  Future<void> login({required int id, required String accessToken, required String refreshToken}) async {
    await Future.wait([
      saveToken(accessToken: accessToken, refreshToken: refreshToken),
      saveId(id: id),
    ]);

    try {
      await NotificationRepository.instance.registerToken();
    } catch (e) {
      logout();
      rethrow;
    }

    if (_isGuest) {
      _isGuest = false;
      notifyListeners();
    }
  }

  loginWithGuest() {
    _isGuest = true;
    notifyListeners();
  }
}
