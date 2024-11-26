import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginModel {
  String email = '';
  String password = '';

  bool validateCredentials() {
    // 이메일과 비밀번호 유효성 검사 로직
    return email.isNotEmpty && password.isNotEmpty;
  }



}
