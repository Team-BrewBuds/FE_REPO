sealed class TokenResult {
  factory TokenResult.success(String access, String refresh) = TokenSuccess; // Option

  factory TokenResult.error(String e) = TokenError; // Option
}

class TokenSuccess implements TokenResult {
  final String access;
  final String refresh;

  TokenSuccess(this.access, this.refresh);
}

class TokenError implements TokenResult {
  final String e;

  TokenError(this.e);
}