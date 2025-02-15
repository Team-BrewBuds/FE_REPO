import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasting_review.freezed.dart';

part 'tasting_review.g.dart';

@freezed
class TastingReview with _$TastingReview {
  const factory TastingReview({
    required int id,
    @JsonKey(name: 'tasted_at') String? tastedAt,
    @JsonKey(name: 'flavor', fromJson: _flavorFromJson) required List<String> flavors,
    required String place,
    required double body,
    required double acidity,
    required double bitterness,
    required double sweetness,
    required double star,
  }) = _TastingReview;

  factory TastingReview.fromJson(Map<String, Object?> json) => _$TastingReviewFromJson(json);
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');
