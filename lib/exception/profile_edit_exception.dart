sealed class ProfileEditException implements Exception {
  final String message;
  const ProfileEditException(this.message);

  @override
  String toString() => message;
}

class InvalidNicknameProfileEditException extends ProfileEditException {
  const InvalidNicknameProfileEditException()
      : super('닉네임은 2자 이상 12자 이하여야 해요.');
}

class NicknameCheckingProfileEditException extends ProfileEditException {
  const NicknameCheckingProfileEditException()
      : super('닉네임 중복 검사 중이에요.');
}

class DuplicateNicknameProfileEditException extends ProfileEditException {
  const DuplicateNicknameProfileEditException()
      : super('이미 사용 중인 닉네임이에요.');
}

class InvalidUrlException extends ProfileEditException {
  const InvalidUrlException()
      : super('유효하지 않은 주소에요.');
}