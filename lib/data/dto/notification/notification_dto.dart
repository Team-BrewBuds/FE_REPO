import 'package:json_annotation/json_annotation.dart';

part 'notification_dto.g.dart';

@JsonSerializable(createToJson: false)
class NotificationDTO {
  final int id;
  final String body;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'is_read')
  final bool isRead;

  const NotificationDTO({
    required this.id,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  factory NotificationDTO.fromJson(Map<String, dynamic> json) => _$NotificationDTOFromJson(json);
}