import 'package:brew_buds/model/common/object_type.dart';

sealed class NotificationModel {
  int get id;

  String get body;

  bool get isRead;

  String get createdAt;

  NotificationModel read();

  NotificationModel unRead();
}

final class FollowNotification implements NotificationModel {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;
  final int? followUserId;

  FollowNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.followUserId,
  });

  @override
  FollowNotification read() {
    return FollowNotification(id: id, body: body, isRead: true, createdAt: createdAt, followUserId: followUserId);
  }

  @override
  FollowNotification unRead() {
    return FollowNotification(id: id, body: body, isRead: false, createdAt: createdAt, followUserId: followUserId);
  }
}

final class CommentNotification implements NotificationModel {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;
  final int? objectId;
  final ObjectType? objectType;

  CommentNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.objectId,
    required this.objectType,
  });

  @override
  CommentNotification read() {
    return CommentNotification(
      id: id,
      body: body,
      isRead: true,
      createdAt: createdAt,
      objectId: objectId,
      objectType: objectType,
    );
  }

  @override
  CommentNotification unRead() {
    return CommentNotification(
        id: id, body: body, isRead: false, createdAt: createdAt, objectId: objectId, objectType: objectType);
  }
}

sealed class LikeNotification implements NotificationModel {}

final class DefaultLikeNotification implements LikeNotification {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;

  DefaultLikeNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
  });

  @override
  DefaultLikeNotification read() {
    return DefaultLikeNotification(id: id, body: body, isRead: true, createdAt: createdAt);
  }

  @override
  DefaultLikeNotification unRead() {
    return DefaultLikeNotification(id: id, body: body, isRead: false, createdAt: createdAt);
  }
}

final class PostLikeNotification implements LikeNotification {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;
  final int? objectId;
  final ObjectType objectType = ObjectType.post;

  PostLikeNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.objectId,
  });

  @override
  PostLikeNotification read() {
    return PostLikeNotification(id: id, body: body, isRead: true, createdAt: createdAt, objectId: objectId);
  }

  @override
  PostLikeNotification unRead() {
    return PostLikeNotification(id: id, body: body, isRead: false, createdAt: createdAt, objectId: objectId);
  }
}

final class TastedRecordLikeNotification implements LikeNotification {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;
  final int? objectId;
  final ObjectType objectType = ObjectType.tastingRecord;

  TastedRecordLikeNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.objectId,
  });

  @override
  TastedRecordLikeNotification read() {
    return TastedRecordLikeNotification(id: id, body: body, isRead: true, createdAt: createdAt, objectId: objectId);
  }

  @override
  TastedRecordLikeNotification unRead() {
    return TastedRecordLikeNotification(id: id, body: body, isRead: false, createdAt: createdAt, objectId: objectId);
  }
}

final class CommentLikeNotification implements LikeNotification {
  @override
  final int id;
  @override
  final String body;
  @override
  final bool isRead;
  @override
  final String createdAt;
  final int? objectId;
  final ObjectType? objectType;

  CommentLikeNotification({
    required this.id,
    required this.body,
    required this.isRead,
    required this.createdAt,
    required this.objectId,
    required this.objectType,
  });

  @override
  CommentLikeNotification read() {
    return CommentLikeNotification(
      id: id,
      body: body,
      isRead: true,
      createdAt: createdAt,
      objectId: objectId,
      objectType: objectType,
    );
  }

  @override
  CommentLikeNotification unRead() {
    return CommentLikeNotification(
      id: id,
      body: body,
      isRead: false,
      createdAt: createdAt,
      objectId: objectId,
      objectType: objectType,
    );
  }
}
