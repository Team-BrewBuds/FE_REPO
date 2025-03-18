import 'package:json_annotation/json_annotation.dart';

part 'coffee_bean_in_calendar_dto.g.dart';

@JsonSerializable(createToJson: false)
class CoffeeBeanInCalendarDTO {
  final int id;
  final String name;
  @JsonKey(name: 'avg_star')
  final double rating;
  @JsonKey(name: 'image_url', defaultValue: '')
  final String thumbnail;


  factory CoffeeBeanInCalendarDTO.fromJson(Map<String, dynamic> json) => _$CoffeeBeanInCalendarDTOFromJson(json);

  const CoffeeBeanInCalendarDTO({
    required this.id,
    required this.name,
    required this.rating,
    required this.thumbnail,
  });
}