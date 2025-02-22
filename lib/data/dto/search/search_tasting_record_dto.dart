import 'package:json_annotation/json_annotation.dart';

part 'search_tasting_record_dto.g.dart';

@JsonSerializable(createToJson: false)
class SearchTastingRecordDTO {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'author_nickname', defaultValue: '')
  final String authorNickname;
  @JsonKey(name: 'content', defaultValue: '')
  final String content;
  @JsonKey(name: 'bean_name', defaultValue: '')
  final String beanName;
  @JsonKey(name: 'bean_type', defaultValue: '')
  final String beanType;
  @JsonKey(name: 'bean_taste', defaultValue: '')
  final String beanTaste;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'star', defaultValue: 0.0)
  final double rating;

  factory SearchTastingRecordDTO.fromJson(Map<String, dynamic> json) => _$SearchTastingRecordDTOFromJson(json);

  const SearchTastingRecordDTO({
    required this.id,
    required this.authorNickname,
    required this.content,
    required this.beanName,
    required this.beanType,
    required this.beanTaste,
    required this.imageUrl,
    required this.rating,
  });
}
