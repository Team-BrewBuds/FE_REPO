import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_type_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_bean_dto.g.dart';

@JsonSerializable(createToJson: false)
class CoffeeBeanDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(
    name: 'bean_type',
    unknownEnumValue: CoffeeBeanTypeDTO.singleOrigin,
    defaultValue: CoffeeBeanTypeDTO.singleOrigin,
  )
  final CoffeeBeanTypeDTO type;
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(name: 'origin_country', fromJson: _stringFromJson, defaultValue: [])
  final List<String> country;
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'is_decaf', defaultValue: false)
  final bool isDecaf;
  @JsonKey(name: 'region', includeIfNull: false)
  String? region;
  @JsonKey(name: 'extraction', includeIfNull: false)
  String? extraction;
  @JsonKey(name: 'roast_point', includeIfNull: false)
  int? roastPoint;
  @JsonKey(name: 'process', fromJson: _stringFromJson, includeIfNull: false)
  List<String>? process;
  @JsonKey(
    name: 'bev_type',
    includeFromJson: false,
    includeIfNull: false,
  )
  bool? beverageType;
  @JsonKey(
    name: 'roastery',
    includeIfNull: false,
  )
  String? roastery;
  @JsonKey(
    name: 'variety',
    includeIfNull: false,
  )
  String? variety;
  @JsonKey(name: 'is_user_created', defaultValue: false)
  final bool isUserCreated;
  @JsonKey(name: 'is_official', defaultValue: false)
  final bool isOfficial;

  factory CoffeeBeanDTO.fromJson(Map<String, dynamic> json) => _$CoffeeBeanDTOFromJson(json);

  static CoffeeBeanDTO defaultCoffeeBean() => CoffeeBeanDTO(
        id: 0,
        type: CoffeeBeanTypeDTO.singleOrigin,
        name: '',
        country: [],
        imageUrl: '',
        isDecaf: false,
        isUserCreated: false,
        isOfficial: false,
      );

  CoffeeBeanDTO({
    required this.id,
    required this.type,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.isDecaf,
    this.region,
    this.extraction,
    this.roastPoint,
    this.process,
    this.beverageType,
    this.roastery,
    this.variety,
    required this.isUserCreated,
    required this.isOfficial,
  });
}

List<String> _stringFromJson(String? json) {
  return json?.split(',').map((e) => e.trim()).where((element) => element.isNotEmpty).toList() ?? [];
}
