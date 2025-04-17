import 'package:json_annotation/json_annotation.dart';

part 'coffee_bean_simple_dto.g.dart';

@JsonSerializable(createToJson: false)
class CoffeeBeanSimpleDTO {
  @JsonKey(name: 'bean_id')
  final int id;
  @JsonKey(name: 'bean__name')
  final String name;

  const CoffeeBeanSimpleDTO({
    required this.id,
    required this.name,
  });

  factory CoffeeBeanSimpleDTO.fromJson(Map<String, dynamic> json) => _$CoffeeBeanSimpleDTOFromJson(json);
}
