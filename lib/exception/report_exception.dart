sealed class ReportException implements Exception {
  final String message;

  const ReportException(this.message);

  @override
  String toString() => message;
}

final class EmptyReasonReportException extends ReportException {
  const EmptyReasonReportException() : super('신고 사유를 선택해 주세요.');
}

final class ReportFailedException extends ReportException {
  const ReportFailedException() : super('신고를 실패했어요.');
}
