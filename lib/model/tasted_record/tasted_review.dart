import 'package:brew_buds/common/extension/date_time_ext.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

  factory TasteReview.empty() => _TasteReview(
        tastedAt: DateTime.now().toDefaultString(),
        flavors: [],
        place: '',
        body: 0,
        acidity: 0,
        bitterness: 0,
        sweetness: 0,
        star: 0.0,
      );
}
