import 'package:json_annotation/json_annotation.dart';

part 'search_bean_dto.g.dart';

@JsonSerializable(createToJson: false)
class SearchBeanDTO {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'name', defaultValue: '')
  final String name;
  @JsonKey(name: 'bean_type', defaultValue: '')
  final String type;
  @JsonKey(name: 'is_decaf', defaultValue: false)
  final bool isDecaf;
  @JsonKey(name: 'origin_country', defaultValue: '')
  final String country;
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'avg_star', defaultValue: 0.0)
  final double rating;
  @JsonKey(name: 'record_count', defaultValue: 0)
  final int tastingRecordCount;

  factory SearchBeanDTO.fromJson(Map<String, dynamic> json) => _$SearchBeanDTOFromJson(json);

  const SearchBeanDTO({
    required this.id,
    required this.name,
    required this.type,
    required this.isDecaf,
    required this.country,
    required this.imageUrl,
    required this.rating,
    required this.tastingRecordCount,
  });
}
