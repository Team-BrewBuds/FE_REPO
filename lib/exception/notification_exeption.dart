sealed class NotificationException implements Exception {
  final String message;

  const NotificationException(this.message);

  @override
  String toString() => message;
}

final class NotificationUpdateException extends NotificationException {
  const NotificationUpdateException() : super('알림 설정 업데이트 중 오류가 발생했어요.');
}

final class UnauthorizedException extends NotificationException {
  const UnauthorizedException() : super('알림 설정 권한이 없어요.');
}
