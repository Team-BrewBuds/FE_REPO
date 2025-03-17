import 'package:json_annotation/json_annotation.dart';

part 'top_flavor_dto.g.dart';

@JsonSerializable(createToJson: false)
class TopFlavorDTO {
  @JsonKey(defaultValue: '')
  final String flavor;
  @JsonKey(name: 'percentage', defaultValue: 0)
  final int percent;

  factory TopFlavorDTO.fromJson(Map<String, dynamic> json) => _$TopFlavorDTOFromJson(json);

  const TopFlavorDTO({
    required this.flavor,
    required this.percent,
  });
}