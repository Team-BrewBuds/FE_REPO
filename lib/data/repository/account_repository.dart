import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  int? _id;
  String _accessToken = '';
  String _refreshToken = '';

  int? get id => _id;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  AccountRepository._() {
    _init();
  }

  static final AccountRepository _instance = AccountRepository._();

  static AccountRepository get instance => _instance;

  factory AccountRepository() => instance;

  _init() async {
    _accessToken = await _storage.read(key: 'access') ?? '';
    _refreshToken = await _storage.read(key: 'refresh') ?? '';
    _id = await _storage.read(key: 'id').then((value) => int.tryParse(value ?? ''), onError: (_) => null);
    notifyListeners();
  }

  Future<void> saveToken({String? accessToken, String? refreshToken}) async {
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

  saveId({required int id}) {
    _storage.write(key: 'id', value: '$id');
    _id = id;
  }
}
