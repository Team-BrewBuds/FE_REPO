sealed class CommentException implements Exception {
  final String message;

  const CommentException(this.message);

  @override
  String toString() => message;
}

final class EmptyCommentException extends CommentException {
  const EmptyCommentException() : super('내용을 작성해 주세요.');
}

final class CommentCreateFailedException extends CommentException {
  const CommentCreateFailedException() : super('댓글 작성에 실패했어요.');
}

final class ReCommentCreateFailedException extends CommentException {
  const ReCommentCreateFailedException() : super('대댓글 작성에 실패했어요.');
}
