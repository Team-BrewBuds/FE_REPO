sealed class SignupException implements Exception {
  final String message;

  const SignupException(this.message);

  @override
  String toString() => message;
}

class InvalidNicknameException extends SignupException {
  const InvalidNicknameException() : super('닉네임은 2자 이상 12자 이하여야 해요.');
}

class NicknameCheckingException extends SignupException {
  const NicknameCheckingException() : super('닉네임 중복 검사 중이에요.');
}

class DuplicateNicknameException extends SignupException {
  const DuplicateNicknameException() : super('이미 사용 중인 닉네임이에요.');
}

class InvalidBirthYearException extends SignupException {
  const InvalidBirthYearException() : super('태어난 연도는 4자리 숫자여야 하고,\n 만 14세 이상이어야 해요.');
}

class InvalidGenderSelectionException extends SignupException {
  const InvalidGenderSelectionException() : super('성별을 선택해주세요.');
}

class EmptyCoffeeLifeSelectionException extends SignupException {
  const EmptyCoffeeLifeSelectionException() : super('커피 생활을 최소 1개 이상 선택해주세요.');
}

class InvalidCertificateSelectionException extends SignupException {
  const InvalidCertificateSelectionException() : super('자격증 보유 여부를 선택해주세요.');
}

class EmptyCoffeePreferenceSelectionException extends SignupException {
  const EmptyCoffeePreferenceSelectionException() : super('커피 취향을 선택해주세요.');
}
