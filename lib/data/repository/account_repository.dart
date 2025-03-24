import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AccountRepository extends ChangeNotifier {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String _refreshToken = '';
  String _accessToken = '';
  int? _id;

  String get accessToken => _accessToken;

  String get refreshToken => _refreshToken;

  int? get id => _id;

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
  }

  saveId({required int id}) {
    _storage.write(key: 'id', value: '$id');
    _id = id;
  }

  Future<bool> logout() async {
    _id = null;
    _accessToken = '';
    _refreshToken = '';
    return _storage.deleteAll().then((value) => true).onError((error, stackTrace) => false);
  }
}
