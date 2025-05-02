import 'package:brew_buds/data/dto/notification/notification_data_dto.dart';
import 'package:brew_buds/data/dto/notification/notification_model_dto.dart';
import 'package:brew_buds/model/notification/notification_model.dart';

extension NotificationMapper on NotificationModelDTO {
  NotificationModel toDomain() {
    final current = this;
    switch (current) {
      case CommentNotificationDTO():
        return CommentNotification(
          id: current.id,
          body: current.body,
          isRead: current.isRead,
          createdAt: _timeAgo(current.createdAt),
          objectId: current.data?.objectId,
          objectType: current.data?.objectType,
        );
      case LikeNotificationDTO():
        final currentData = current.data;
        switch (currentData) {
          case null:
            return DefaultLikeNotification(
              id: current.id,
              body: current.body,
              isRead: current.isRead,
              createdAt: _timeAgo(current.createdAt),
            );
          case PostLikeNotificationDataDTO():
            return PostLikeNotification(
              id: current.id,
              body: current.body,
              isRead: current.isRead,
              createdAt: _timeAgo(current.createdAt),
              objectId: currentData.postId,
            );
          case TastedRecordLikeNotificationDataDTO():
            return TastedRecordLikeNotification(
              id: current.id,
              body: current.body,
              isRead: current.isRead,
              createdAt: _timeAgo(current.createdAt),
              objectId: currentData.tastedRecordId,
            );
          case CommentLikeNotificationDataDTO():
            return CommentLikeNotification(
              id: current.id,
              body: current.body,
              isRead: current.isRead,
              createdAt: _timeAgo(current.createdAt),
              objectId: currentData.objectId,
              objectType: currentData.objectType,
            );
        }
      case FollowNotificationDTO():
        return FollowNotification(
          id: current.id,
          body: current.body,
          isRead: current.isRead,
          createdAt: _timeAgo(current.createdAt),
          followUserId: current.data?.followerUserId,
        );
    }
  }

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
