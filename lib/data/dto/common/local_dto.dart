import 'package:json_annotation/json_annotation.dart';

part 'local_dto.g.dart';

@JsonSerializable(createToJson: false)
class LocalDTO {
  @JsonKey(name: 'place_name')
  final String name;
  final String distance;
  @JsonKey(name: 'road_address_name')
  final String address;

  factory LocalDTO.fromJson(Map<String, dynamic> json) => _$LocalDTOFromJson(json);

  const LocalDTO({
    required this.name,
    required this.distance,
    required this.address,
  });
}
