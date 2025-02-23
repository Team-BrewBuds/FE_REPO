import 'package:brew_buds/filter/model/bean_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'coffee_bean.freezed.dart';

part 'coffee_bean.g.dart';

@freezed
class CoffeeBean with _$CoffeeBean {
  const factory CoffeeBean({
    required int id,
    @JsonKey(name: 'bean_type') required BeanType type,
    required String name,
    @JsonKey(name: 'region') String? region,
    @JsonKey(name: 'origin_country', fromJson: _countryFromJson) required List<String> country,
    @JsonKey(name: 'image_url') String? imageUri,
    @JsonKey(name: 'is_decaf') bool? isDecaf,
    @JsonKey(name: 'extraction') String? extraction,
    @JsonKey(name: 'roast_point') double? roastPoint,
    @JsonKey(name: 'process') String? process,
    @JsonKey(name: 'bev_type') bool? beverageType,
    @JsonKey(name: 'roastery') String? roastery,
    @JsonKey(name: 'variety') String? variety,
    @JsonKey(name: 'is_user_created') bool? isUserCreated,
    @JsonKey(name: 'is_official') bool? isOfficial,
  }) = _CoffeeBean;

  factory CoffeeBean.fromJson(Map<String, Object?> json) => _$CoffeeBeanFromJson(json);
}

List<String> _countryFromJson(String? json) {
  return json?.split(',').toList() ?? [];
}
