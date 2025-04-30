import 'package:brew_buds/model/common/object_type.dart';

final class CommentNotificationDataDTO {
  final int commentId;
  final int objectId;
  final ObjectType objectType;

  const CommentNotificationDataDTO({
    required this.commentId,
    required this.objectId,
    required this.objectType,
  });

  factory CommentNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    return CommentNotificationDataDTO(
      commentId: int.parse(json['comment_id'] as String),
      objectId: int.parse(json['object_id'] as String),
      objectType: _objectTypeMap[json['object_type'] as String]!,
    );
  }

  static final Map<String, ObjectType> _objectTypeMap = {
    '시음 기록': ObjectType.tastingRecord,
    '게시물': ObjectType.post,
  };
}

final class FollowNotificationDataDTO {
  final int followerUserId;

  const FollowNotificationDataDTO({
    required this.followerUserId,
  });

  factory FollowNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    return FollowNotificationDataDTO(followerUserId: int.parse(json['follower_user_id'] as String));
  }
}

sealed class LikeNotificationDataDTO {
  factory LikeNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('comment_id')) {
      return CommentLikeNotificationDataDTO.fromJson(json);
    } else if (json.containsKey('post_id')) {
      return PostLikeNotificationDataDTO.fromJson(json);
    } else if (json.containsKey('tasted_record_id')) {
      return TastedRecordLikeNotificationDataDTO.fromJson(json);
    } else {
      throw UnsupportedError('Unknown Like Type');
    }
  }
}

final class PostLikeNotificationDataDTO implements LikeNotificationDataDTO {
  final int postId;

  PostLikeNotificationDataDTO({
    required this.postId,
  });

  factory PostLikeNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    return PostLikeNotificationDataDTO(postId: int.parse(json['post_id'] as String));
  }
}

final class TastedRecordLikeNotificationDataDTO implements LikeNotificationDataDTO {
  final int tastedRecordId;

  TastedRecordLikeNotificationDataDTO({
    required this.tastedRecordId,
  });

  factory TastedRecordLikeNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    return TastedRecordLikeNotificationDataDTO(tastedRecordId: int.parse(json['tasted_record_id'] as String));
  }
}

final class CommentLikeNotificationDataDTO implements LikeNotificationDataDTO {
  final int commentId;
  final int objectId;
  final ObjectType objectType;

  CommentLikeNotificationDataDTO({
    required this.commentId,
    required this.objectId,
    required this.objectType,
  });

  factory CommentLikeNotificationDataDTO.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('tasted_record_id')) {
      return CommentLikeNotificationDataDTO(
        commentId: int.parse(json['comment_id'] as String),
        objectId: int.parse(json['tasted_record_id'] as String),
        objectType: ObjectType.tastingRecord,
      );
    } else if (json.containsKey('post_id')) {
      return CommentLikeNotificationDataDTO(
        commentId: int.parse(json['comment_id'] as String),
        objectId: int.parse(json['post_id'] as String),
        objectType: ObjectType.post,
      );
    } else {
      throw UnsupportedError('Unknown Comment Like Type');
    }
  }
}
