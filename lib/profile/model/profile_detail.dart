import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile_detail.freezed.dart';

part 'profile_detail.g.dart';

@freezed
class ProfileDetail with _$ProfileDetail {
  const factory ProfileDetail({
    required String? introduction,
    @JsonKey(name: 'profile_link', defaultValue: null, includeIfNull: false) required String? profileLink,
    @JsonKey(name: 'coffee_life', fromJson: _coffeeLifeFromJson, defaultValue: null, includeIfNull: false) required List<CoffeeLife>? coffeeLife,
    @JsonKey(name: 'preferred_bean_taste', defaultValue: null, includeIfNull: false) required PreferredBeanTaste? preferredBeanTasted,
    @JsonKey(name: 'is_certificated', defaultValue: null, includeIfNull: false) required bool? isCertificated,
  }) = _ProfileDetail;

  factory ProfileDetail.fromJson(Map<String, Object?> json) => _$ProfileDetailFromJson(json);
}

List<CoffeeLife> _coffeeLifeFromJson(Map<String, dynamic> json) {
  final List<CoffeeLife> result = [];
  json.forEach((key, value) {
    if (value) {
      switch (key) {
        case 'cafe_tour':
          result.add(CoffeeLife.cafeTour);
          break;
        case 'coffee_extraction':
          result.add(CoffeeLife.coffeeExtraction);
          break;
        case 'coffee_study':
          result.add(CoffeeLife.coffeeStudy);
          break;
        case 'cafe_alba':
          result.add(CoffeeLife.cafeAlba);
          break;
        case 'cafe_work':
          result.add(CoffeeLife.cafeWork);
          break;
        case 'cafe_operation':
          result.add(CoffeeLife.cafeOperation);
          break;
      }
    }
  });
  return result;
}
