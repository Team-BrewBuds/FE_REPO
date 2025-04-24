sealed class CoffeeNotePostException implements Exception {
  String get message;
}

final class ShortTitleLength implements CoffeeNotePostException {
  @override
  String get message => '제목을 2글자 이상 입력해주세요.';
}

final class ShortContentsLength implements CoffeeNotePostException {
  @override
  String get message => '내용을 8글자 이상 입력해주세요.';
}

final class SubjectNotFound implements CoffeeNotePostException {
  @override
  String get message => '게시글의 주제를 선택해주세요.';
}

final class ApiError implements CoffeeNotePostException {
  @override
  String get message => '게시글 수정에 실패했어요.';
}