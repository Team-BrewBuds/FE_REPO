import 'package:json_annotation/json_annotation.dart';

part 'noted_tasted_record_dto.g.dart';

@JsonSerializable(createToJson: false)
class NotedTastedRecordDTO {
  @JsonKey(name: 'tasted_record_id', defaultValue: 0)
  final int id;
  @JsonKey(name: 'bean_name', defaultValue: '')
  final String beanName;
  @JsonKey(fromJson: _flavorFromJson, defaultValue: [])
  final List<String> flavor;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'star', defaultValue: 0.0)
  final double rating;
  
  factory NotedTastedRecordDTO.fromJson(Map<String, dynamic> json) => _$NotedTastedRecordDTOFromJson(json);

  const NotedTastedRecordDTO({
    required this.id,
    required this.beanName,
    required this.flavor,
    required this.imageUrl,
    required this.rating,
  });
}

List<String> _flavorFromJson(String json) {
  return json.split(',').map((e) => e.trim()).where((element) => element.isNotEmpty).toList();
}