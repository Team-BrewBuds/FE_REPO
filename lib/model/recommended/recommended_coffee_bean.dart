import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_coffee_bean.freezed.dart';

@freezed
class RecommendedCoffeeBean with _$RecommendedCoffeeBean {
  const factory RecommendedCoffeeBean({
    required int id,
    required String name,
    required String imagePath,
    required double rating,
    required int recordCount,
  }) = _RecommendedCoffeeBean;
}
