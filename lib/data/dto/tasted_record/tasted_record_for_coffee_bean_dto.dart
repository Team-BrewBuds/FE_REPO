import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_type_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_for_coffee_bean_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordInCoffeeBeanDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(name: 'author', defaultValue: '')
  final String nickname;
  @JsonKey(name: 'content', defaultValue: '')
  final String contents;
  @JsonKey(name: 'bean_name', defaultValue: '')
  final String beanName;
  @JsonKey(name: 'star', defaultValue: 0)
  final int rating;
  @JsonKey(name: 'bean_type', defaultValue: CoffeeBeanTypeDTO.singleOrigin)
  final CoffeeBeanTypeDTO beanType;
  @JsonKey(name: 'bean_taste', fromJson: _flavorFromJson, defaultValue: [])
  final List<String> flavors;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String photoUrl;

  factory TastedRecordInCoffeeBeanDTO.fromJson(Map<String, dynamic> json) =>
      _$TastedRecordInCoffeeBeanDTOFromJson(json);

  const TastedRecordInCoffeeBeanDTO({
    required this.id,
    required this.nickname,
    required this.contents,
    required this.beanName,
    required this.rating,
    required this.beanType,
    required this.flavors,
    required this.photoUrl,
  });
}

List<String> _flavorFromJson(String? json) {
  return json?.split(',').toList() ?? [];
}
