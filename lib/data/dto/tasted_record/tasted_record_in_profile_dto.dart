import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_in_profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordInProfileDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(name: 'bean_name', defaultValue: '')
  final String beanName;
  @JsonKey(name: 'star', defaultValue: 0.0)
  final double rating;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'likes', defaultValue: 0)
  final int likeCount;

  factory TastedRecordInProfileDTO.fromJson(Map<String, dynamic> json) => _$TastedRecordInProfileDTOFromJson(json);

  const TastedRecordInProfileDTO({
    required this.id,
    required this.beanName,
    required this.rating,
    required this.imageUrl,
    required this.likeCount,
  });
}
