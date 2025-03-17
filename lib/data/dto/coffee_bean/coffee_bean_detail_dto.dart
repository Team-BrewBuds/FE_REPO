import 'package:brew_buds/data/dto/coffee_bean/bean_taste_dto.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_type_dto.dart';
import 'package:brew_buds/data/dto/common/top_flavor_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coffee_bean_detail_dto.g.dart';

@JsonSerializable(createToJson: false)
class CoffeeBeanDetailDTO {
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
  @JsonKey(name: 'origin_country', fromJson: _countryFromJson, defaultValue: [])
  final List<String> country;
  @JsonKey(name: 'image_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'is_decaf', defaultValue: false)
  final bool isDecaf;
  @JsonKey(name: 'avg_star', defaultValue: '')
  final String rating;
  @JsonKey(name: 'record_count', defaultValue: 0)
  final int recordCount;
  @JsonKey(name: 'top_flavors', defaultValue: <TopFlavorDTO>[])
  final List<TopFlavorDTO> topFlavors;
  @JsonKey(name: 'bean_taste', defaultValue: BeanTasteDTO.defaultBeanTaste)
  final BeanTasteDTO beanTaste;
  @JsonKey(includeIfNull: false, name: 'region')
  String? region;
  @JsonKey(includeIfNull: false, name: 'extraction')
  String? extraction;
  @JsonKey(includeIfNull: false, name: 'roast_point')
  int? roastPoint;
  @JsonKey(includeIfNull: false, name: 'process')
  String? process;
  @JsonKey(includeIfNull: false, name: 'bev_type')
  bool? beverageType;
  @JsonKey(includeIfNull: false, name: 'roastery')
  String? roastery;
  @JsonKey(includeIfNull: false, name: 'variety')
  String? variety;
  @JsonKey(name: 'is_user_noted', defaultValue: false)
  final bool isUserNoted;
  @JsonKey(name: 'is_user_created', defaultValue: false)
  final bool isUserCreated;
  @JsonKey(name: 'is_official', defaultValue: false)
  final bool isOfficial;

  factory CoffeeBeanDetailDTO.fromJson(Map<String, dynamic> json) => _$CoffeeBeanDetailDTOFromJson(json);

  CoffeeBeanDetailDTO({
    required this.id,
    required this.type,
    required this.name,
    required this.country,
    required this.imageUrl,
    required this.isDecaf,
    required this.rating,
    required this.recordCount,
    required this.topFlavors,
    required this.beanTaste,
    this.region,
    this.extraction,
    this.roastPoint,
    this.process,
    this.beverageType,
    this.roastery,
    this.variety,
    required this.isUserNoted,
    required this.isUserCreated,
    required this.isOfficial,
  });
}

List<String> _countryFromJson(String? json) {
  return json?.split(',').toList() ?? [];
}
