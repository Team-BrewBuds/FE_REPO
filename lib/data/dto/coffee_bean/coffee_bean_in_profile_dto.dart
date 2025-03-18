import 'package:json_annotation/json_annotation.dart';

part 'coffee_bean_in_profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class CoffeeBeanInProfileDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(name: 'origin_country', defaultValue: '')
  final String country;
  @JsonKey(name: 'roast_point', defaultValue: 0)
  final int roastingPoint;
  @JsonKey(name: 'avg_star', defaultValue: '')
  final String rating;
  @JsonKey(name: 'tasted_records_cnt', defaultValue: 0)
  final int tastedRecordsCount;

  factory CoffeeBeanInProfileDTO.fromJson(Map<String, dynamic> json) => _$CoffeeBeanInProfileDTOFromJson(json);

  const CoffeeBeanInProfileDTO({
    required this.id,
    required this.name,
    required this.country,
    required this.roastingPoint,
    required this.rating,
    required this.tastedRecordsCount,
  });
}