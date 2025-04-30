sealed class NotificationTapAction {}

final class JustTap implements NotificationTapAction {}

final class PushToPostDetail implements NotificationTapAction {
  final int id;

  PushToPostDetail({required this.id});
}

final class PushToTastedRecordDetail implements NotificationTapAction {
  final int id;

  PushToTastedRecordDetail({required this.id});
}

final class PushToProfile implements NotificationTapAction {
  final int id;

  PushToProfile({required this.id});
}