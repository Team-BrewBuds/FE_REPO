sealed class SocialLoginToken {
  String get token;

  factory SocialLoginToken.kakao(String token) = KakaoToken;

  factory SocialLoginToken.naver(String token) = NaverToken;

  factory SocialLoginToken.apple(String token) = AppleToken;
}

final class KakaoToken implements SocialLoginToken {
  final String _token;

  const KakaoToken(String token) : _token = token;

  @override
  String get token => _token;
}

final class NaverToken implements SocialLoginToken {
  final String _token;

  const NaverToken(String token) : _token = token;

  @override
  String get token => _token;
}

final class AppleToken implements SocialLoginToken {
  final String _token;

  const AppleToken(String token) : _token = token;

  @override
  String get token => _token;
}