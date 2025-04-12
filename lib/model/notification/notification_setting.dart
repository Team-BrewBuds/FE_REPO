import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_setting.freezed.dart';

@freezed
class NotificationSetting with _$NotificationSetting {
  const factory NotificationSetting({
    required bool like,
    required bool comment,
    required bool follow,
    required bool marketing,
  }) = _NotificationSetting;
}
