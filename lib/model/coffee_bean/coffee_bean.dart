import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'coffee_bean.freezed.dart';

part 'coffee_bean.g.dart';

@freezed
class CoffeeBean with _$CoffeeBean {
  const factory CoffeeBean({
    @JsonKey(includeToJson: false) required int id,
    @JsonKey(name: 'bean_type') CoffeeBeanType? type,
    String? name,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'region') String? region,
    @JsonKey(name: 'origin_country', fromJson: _countryFromJson, toJson: _countryToJson, includeIfNull: false)
    List<String>? country,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'image_url') String? imageUri,
    @JsonKey(includeIfNull: false, name: 'is_decaf') bool? isDecaf,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'extraction') String? extraction,
    @JsonKey(includeIfNull: false, name: 'roast_point') int? roastPoint,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'process') String? process,
    @JsonKey(includeIfNull: false, name: 'bev_type') bool? beverageType,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'roastery') String? roastery,
    @JsonKey(includeIfNull: false, toJson: _nullableStringToJson, name: 'variety') String? variety,
    @JsonKey(includeIfNull: false, name: 'is_user_created') bool? isUserCreated,
    @JsonKey(includeIfNull: false, name: 'is_official') bool? isOfficial,
  }) = _CoffeeBean;

  factory CoffeeBean.fromJson(Map<String, Object?> json) => _$CoffeeBeanFromJson(json);

  factory CoffeeBean.empty() => const _CoffeeBean(id: 0);
}

List<String> _countryFromJson(String? json) {
  return json?.split(',').toList() ?? [];
}

String? _countryToJson(List<String>? country) {
  return country?.where((element) => element.isNotEmpty).join(',');
}

String? _nullableStringToJson(String? text) => (text ?? '').isEmpty ? null : text;
