sealed class LoginResult {
  factory LoginResult.success(bool hasAccount, String token) = LoginSuccess; // Option

  factory LoginResult.error(String e) = LoginError; // Option
}

class LoginSuccess implements LoginResult {
  final bool hasAccount;
  final String token;

  LoginSuccess(this.hasAccount, this.token);
}

class LoginError implements LoginResult {
  final String e;

  LoginError(this.e);
}
