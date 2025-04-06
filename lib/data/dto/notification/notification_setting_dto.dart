import 'package:json_annotation/json_annotation.dart';

part 'notification_setting_dto.g.dart';

@JsonSerializable()
class NotificationSettingDTO {
  @JsonKey(name: 'like_notify', defaultValue: false)
  final bool like;
  @JsonKey(name: 'comment_notify', defaultValue: false)
  final bool comment;
  @JsonKey(name: 'follow_notify', defaultValue: false)
  final bool follow;
  @JsonKey(name: 'marketing_notify', defaultValue: false)
  final bool marketing;

  const NotificationSettingDTO({
    required this.like,
    required this.comment,
    required this.follow,
    required this.marketing,
  });

  factory NotificationSettingDTO.fromJson(Map<String, dynamic> json) => _$NotificationSettingDTOFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationSettingDTOToJson(this);
}
