import 'package:json_annotation/json_annotation.dart';

part 'recommended_coffee_bean_dto.g.dart';

@JsonSerializable(createToJson: false)
class RecommendedCoffeeBeanDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'avg_star', defaultValue: 0.0)
  final double rating;
  @JsonKey(name: 'record_cnt', defaultValue: 0)
  final int recordCount;

  factory RecommendedCoffeeBeanDTO.fromJson(Map<String, dynamic> json) => _$RecommendedCoffeeBeanDTOFromJson(json);

  const RecommendedCoffeeBeanDTO({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.recordCount,
  });
}
