import 'package:json_annotation/json_annotation.dart';

part 'top_flavor_int_dto.g.dart';

@JsonSerializable(createToJson: false)
class TopFlavorIntDTO {
  @JsonKey(defaultValue: '')
  final String flavor;
  @JsonKey(name: 'percentage', defaultValue: 0)
  final int percent;

  const TopFlavorIntDTO({
    required this.flavor,
    required this.percent,
  });

  factory TopFlavorIntDTO.fromJson(Map<String, dynamic> json) => _$TopFlavorIntDTOFromJson(json);
}
