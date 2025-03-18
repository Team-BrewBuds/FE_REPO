import 'package:json_annotation/json_annotation.dart';

part 'preferred_bean_taste_dto.g.dart';

@JsonSerializable(createToJson: false)
class PreferredBeanTasteDTO {
  @JsonKey(defaultValue: 0)
  final int body;
  @JsonKey(defaultValue: 0)
  final int acidity;
  @JsonKey(defaultValue: 0)
  final int bitterness;
  @JsonKey(defaultValue: 0)
  final int sweetness;

  factory PreferredBeanTasteDTO.fromJson(Map<String, dynamic> json) => _$PreferredBeanTasteDTOFromJson(json);

  factory PreferredBeanTasteDTO.empty() => const PreferredBeanTasteDTO(body: 0, acidity: 0, bitterness: 0, sweetness: 0);

  const PreferredBeanTasteDTO({
    required this.body,
    required this.acidity,
    required this.bitterness,
    required this.sweetness,
  });
}