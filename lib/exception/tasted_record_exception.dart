sealed class TastedRecordException implements Exception {
  final String message;

  const TastedRecordException(this.message);

  @override
  String toString() => message;
}

final class ImageUploadFailedException extends TastedRecordException {
  const ImageUploadFailedException() : super('사진 등록에 실패했어요.');
}

final class TastingRecordWriteFailedException extends TastedRecordException {
  const TastingRecordWriteFailedException() : super('시음기록 작성에 실패했어요.');
}

final class TastingRecordUpdateFailedException extends TastedRecordException {
  const TastingRecordUpdateFailedException() : super('시음기록 수정에 실패했어요.');
}