import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_in_post_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordInPostDTO {
  @JsonKey(defaultValue: 0)final int id;
  @JsonKey(name: 'bean_name', defaultValue: '') final String beanName;
  @JsonKey(name: 'bean_type', defaultValue: '') final String beanType;
  @JsonKey(name: 'content', defaultValue:'') final String contents;
  @JsonKey(name: 'star_rating', defaultValue: 0) final double rating;
  @JsonKey(name: 'flavor', fromJson: _flavorFromJson, defaultValue: []) final List<String> flavors;
  @JsonKey(name: 'photos', fromJson: _photosFromJson, defaultValue: []) final List<String> imagesUrl;

  factory TastedRecordInPostDTO.fromJson(Map<String, dynamic> json) => _$TastedRecordInPostDTOFromJson(json);

  const TastedRecordInPostDTO({
    required this.id,
    required this.beanName,
    required this.beanType,
    required this.contents,
    required this.rating,
    required this.flavors,
    required this.imagesUrl,
  });
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}