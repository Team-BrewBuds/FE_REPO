sealed class LoginException implements Exception {
  String get message;
}

final class EmptyDeviceTokenException implements LoginException {
  @override
  // TODO: implement message
  String get message => '디바이스 정보를 불러오는데 실패했어요.';
}

final class DeviceRegistrationException implements LoginException {
  @override
  // TODO: implement message
  String get message => '디바이스 정보 등록에 실패했어요.';
}

final class SocialLoginApiException implements LoginException {
  @override
  // TODO: implement message
  String get message => '로그인 정보를 불러오는데 실패했어요.';
}

final class SocialLoginRegistrationException implements LoginException {
  @override
  // TODO: implement message
  String get message => '소셜로그인 정보 등록에 실패했어요.';
}

final class SocialLoginFailedException implements LoginException {
  @override
  // TODO: implement message
  String get message => '소셜로그인을 실패했어요.';
}
