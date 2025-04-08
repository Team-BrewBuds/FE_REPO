import 'package:brew_buds/data/dto/notification/notification_dto.dart';
import 'package:brew_buds/model/notification/notification_model.dart';

extension NotificationMapper on NotificationDTO {
  NotificationModel toDomain() => NotificationModel(
        id: id,
        body: body,
        createdAt: _timeAgo(createdAt),
        isRead: isRead,
      );

  String _timeAgo(String isoString) {
    final now = DateTime.now();
    final dateTime = DateTime.parse(isoString);
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) {
      return '방금 전';
    } else if (diff.inMinutes < 60) {
      return '${diff.inMinutes}분 전';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}시간 전';
    } else if (diff.inDays < 30) {
      return '${diff.inDays}일 전';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}달 전';
    } else {
      return '${(diff.inDays / 365).floor()}년 전';
    }
  }
}
