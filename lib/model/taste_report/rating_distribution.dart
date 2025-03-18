import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'rating_distribution.freezed.dart';

@freezed
class RatingDistribution with _$RatingDistribution {
  const factory RatingDistribution({
    required Map<String, int> ratingDistribution,
    required double mostRating,
    required double avgRating,
    required int ratingCount,
  }) = _RatingDistribution;
}