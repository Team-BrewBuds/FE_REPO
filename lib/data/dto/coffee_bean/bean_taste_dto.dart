import 'package:json_annotation/json_annotation.dart';

part 'bean_taste_dto.g.dart';

@JsonSerializable(createToJson: false)
class BeanTasteDTO {
  @JsonKey(name: 'flavor', defaultValue: [], fromJson: _flavorFromJson)
  final List<String> flavors;
  @JsonKey(defaultValue: 0)
  final int body;
  @JsonKey(defaultValue: 0)
  final int acidity;
  @JsonKey(defaultValue: 0)
  final int bitterness;
  @JsonKey(defaultValue: 0)
  final int sweetness;

  factory BeanTasteDTO.fromJson(Map<String, dynamic> json) => _$BeanTasteDTOFromJson(json);

  static BeanTasteDTO defaultBeanTaste() => const BeanTasteDTO(
        flavors: [],
        body: 0,
        acidity: 0,
        bitterness: 0,
        sweetness: 0,
      );

  const BeanTasteDTO({
    required this.flavors,
    required this.body,
    required this.acidity,
    required this.bitterness,
    required this.sweetness,
  });
}

List<String> _flavorFromJson(String? json) {
  return json?.split(',').toList() ?? [];
}
