import 'package:json_annotation/json_annotation.dart';

part 'top_origin_dto.g.dart';

@JsonSerializable(createToJson: false)
class TopOriginDTO {
  @JsonKey(defaultValue: '')
  final String origin;
  @JsonKey(name: 'percentage', defaultValue: '')
  final String percent;

  factory TopOriginDTO.fromJson(Map<String, dynamic> json) => _$TopOriginDTOFromJson(json);

  const TopOriginDTO({
    required this.origin,
    required this.percent,
  });
}