import 'package:brew_buds/data/dto/notification/notification_data_dto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model_dto.freezed.dart';

part 'notification_model_dto.g.dart';

@Freezed(unionKey: 'notification_type', toJson: false, copyWith: false)
sealed class NotificationModelDTO with _$NotificationModelDTO {
  const NotificationModelDTO._();

  @FreezedUnionValue('comment')
  factory NotificationModelDTO.comment({
    required int id,
    required String body,
    @JsonKey(fromJson: _commentNotificationDataDTOFromJson) required CommentNotificationDataDTO? data,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = CommentNotificationDTO;

  @FreezedUnionValue('like')
  factory NotificationModelDTO.like({
    required int id,
    required String body,
    @JsonKey(fromJson: _likeNotificationDataDTOFromJson) required LikeNotificationDataDTO? data,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = LikeNotificationDTO;

  @FreezedUnionValue('follow')
  factory NotificationModelDTO.follow({
    required int id,
    required String body,
    @JsonKey(fromJson: _followNotificationDataDTOFromJson) required FollowNotificationDataDTO? data,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'created_at') required String createdAt,
  }) = FollowNotificationDTO;

  factory NotificationModelDTO.fromJson(Map<String, Object?> json) => _$NotificationModelDTOFromJson(json);
}

LikeNotificationDataDTO? _likeNotificationDataDTOFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return LikeNotificationDataDTO.fromJson(json);
  } catch (e) {
    return null;
  }
}

CommentNotificationDataDTO? _commentNotificationDataDTOFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return CommentNotificationDataDTO.fromJson(json);
  } catch (e) {
    return null;
  }
}

FollowNotificationDataDTO? _followNotificationDataDTOFromJson(Object? json) {
  if (json is! Map<String, dynamic>) return null;
  try {
    return FollowNotificationDataDTO.fromJson(json);
  } catch (e) {
    return null;
  }
}