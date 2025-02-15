import 'package:json_annotation/json_annotation.dart';

part 'bean_in_profile.g.dart';

@JsonSerializable(createToJson: false)
class BeanInProfile {
  final int id;
  final String name;
  @JsonKey(name: 'origin_country')
  final String country;
  @JsonKey(name: 'roast_point')
  final int roastingPoint;
  @JsonKey(name: 'avg_star')
  final String rating;
  @JsonKey(name: 'tasted_records_cnt')
  final int tastedRecordsCount;

  BeanInProfile(
    this.id,
    this.name,
    this.country,
    this.roastingPoint,
    this.rating,
    this.tastedRecordsCount,
  );

  factory BeanInProfile.fromJson(Map<String, dynamic> json) => _$BeanInProfileFromJson(json);
}
