sealed class ProfileUpdateException implements Exception {
  final String message;

  const ProfileUpdateException(this.message);

  @override
  String toString() => message;
}

class IsShortNicknameProfileEditException extends ProfileUpdateException {
  const IsShortNicknameProfileEditException() : super('닉네임은 2자 이상 12자 이하여야 해요.');
}

class InvalidNicknameProfileEditException extends ProfileUpdateException {
  const InvalidNicknameProfileEditException() : super('올바르지 않은 닉네임 이에요.');
}

class NicknameCheckingProfileEditException extends ProfileUpdateException {
  const NicknameCheckingProfileEditException() : super('닉네임 중복 검사 중이에요.');
}

class DuplicateNicknameProfileEditException extends ProfileUpdateException {
  const DuplicateNicknameProfileEditException() : super('이미 사용 중인 닉네임이에요.');
}

class IntroductionContainsBadWordsProfileEditException extends ProfileUpdateException {
  const IntroductionContainsBadWordsProfileEditException() : super('소개글에 부적절한 언어가 포함되어 있어요.');
}

class InvalidUrlException extends ProfileUpdateException {
  const InvalidUrlException() : super('유효하지 않은 주소에요.');
}
