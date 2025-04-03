import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  bool _isGuest = false;
  bool _forceLogout = false;
  String _refreshToken = '';
  String _accessToken = '';
  int? _id;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  int? get id => _id;

  bool get isForceLogout => _forceLogout;

  bool get isGuest => _isGuest;

  AccountRepository._();

  static final AccountRepository _instance = AccountRepository._();

  static AccountRepository get instance => _instance;

  factory AccountRepository() => instance;

  init() async {
    _accessToken = await _storage.read(key: 'access') ?? '';
    _refreshToken = await _storage.read(key: 'refresh') ?? '';
    _id = int.tryParse(await _storage.read(key: 'id') ?? '');
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

    notifyListeners();
  }

  Future<void> saveId({required int id}) async {
    await _storage.write(key: 'id', value: '$id');
    _id = id;
  }

  Future<void> logout({bool forceLogout = false}) async {
    try {
      await NotificationRepository.instance.deleteToken();
      await _storage.deleteAll();
      _id = null;
      _accessToken = '';
      _refreshToken = '';
      _forceLogout = forceLogout;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> login({required int id, required String accessToken, required String refreshToken}) async {
    await saveToken(accessToken: accessToken, refreshToken: refreshToken);
    await saveId(id: id);
    if (_isGuest) {
      _isGuest = false;
      notifyListeners();
    }
  }

  loginWithGuest() {
    _isGuest = true;
  }

  setForceLogout({required bool value}) {
    _forceLogout = value;
  }
}
