sealed class PostException {
  final String message;

  const PostException(this.message);

  @override
  String toString() => message;
}

class InvalidTitleException extends PostException {
  const InvalidTitleException() : super('제목을 2자 이상 입력해 주세요.');
}

class InvalidContentsException extends PostException {
  const InvalidContentsException() : super('내용을 8자 이상 입력해주세요.');
}

class ContainsBadWordsException extends PostException {
  const ContainsBadWordsException() : super('제목 또는 내용에 부적절한 단어가 포함되어 있어요.');
}

final class ImageUploadFailedException extends PostException {
  const ImageUploadFailedException() : super('사진 등록에 실패했어요.');
}

final class TastedRecordUploadFailedException extends PostException {
  const TastedRecordUploadFailedException() : super('시음기록 등록에 실패했어요.');
}

final class MultiUploadException extends PostException {
  const MultiUploadException() : super('사진, 시음기록 중 한 종류만 첨부할 수 있어요.');
}

final class EmptySubjectException extends PostException {
  const EmptySubjectException() : super('주제를 선택해주세요.');
}

final class PostWriteFailedException extends PostException {
  const PostWriteFailedException() : super('게시글 작성에 실패했어요.');
}

final class PostUpdateFailedException extends PostException {
  const PostUpdateFailedException() : super('게시글 수정에 실패했어요.');
}
