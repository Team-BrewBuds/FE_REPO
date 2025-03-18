import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_in_calendar_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordInCalendarDTO {
  final int id;
  @JsonKey(name: 'title', defaultValue: '')
  final String beanName;
  @JsonKey(name: 'star', defaultValue: 0.0)
  final double rating;
  @JsonKey(name: 'flavor', fromJson: _flavorFromJson, defaultValue: [])
  final List<String> flavors;
  @JsonKey(name: 'first_photo', defaultValue: '')
  final String thumbnail;

  factory TastedRecordInCalendarDTO.fromJson(Map<String, dynamic> json) => _$TastedRecordInCalendarDTOFromJson(json);

  const TastedRecordInCalendarDTO({
    required this.id,
    required this.beanName,
    required this.rating,
    required this.flavors,
    required this.thumbnail,
  });
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');