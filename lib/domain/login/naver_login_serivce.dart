import 'package:flutter/services.dart';

class NaverLoginService {
  static const _ch = MethodChannel('com.brewbuds/naver_login');

  static Future<Map<String, dynamic>?> login() async {
    final res = await _ch.invokeMethod('login');
    if (res == null) return null;
    return Map<String, dynamic>.from(res as Map);
  }

  static Future<void> logout() async {
    await _ch.invokeMethod('logout');
  }
}