sealed class SocialLoginToken {
  String get token;

  String get platform;

  factory SocialLoginToken.kakao(String token) = KakaoToken;

  factory SocialLoginToken.naver(String token) = NaverToken;

  factory SocialLoginToken.apple(String token) = AppleToken;
}

final class KakaoToken implements SocialLoginToken {
  final String _token;
  final String _platform = 'kakao';

  const KakaoToken(String token) : _token = token;

  @override
  String get token => _token;

  @override
  String get platform => _platform;
}

final class NaverToken implements SocialLoginToken {
  final String _token;
  final String _platform = 'naver';

  const NaverToken(String token) : _token = token;

  @override
  String get token => _token;

  @override
  String get platform => _platform;
}

final class AppleToken implements SocialLoginToken {
  final String _token;
  final String _platform = 'apple';

  const AppleToken(String token) : _token = token;

  @override
  String get token => _token;

  @override
  String get platform => _platform;
}
