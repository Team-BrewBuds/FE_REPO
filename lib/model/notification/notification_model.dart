import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_model.freezed.dart';

@freezed
class NotificationModel with _$NotificationModel {
  const factory NotificationModel({
    required int id,
    required String body,
    required String createdAt,
    required bool isRead,
  }) = _NotificationModel;
}
