import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasted_review.freezed.dart';

@freezed
class TasteReview with _$TasteReview {
  const factory TasteReview({
    required String tastedAt,
    required List<String> flavors,
    required String place,
    required int body,
    required int acidity,
    required int bitterness,
    required int sweetness,
    required double star,
  }) = _TasteReview;
}
