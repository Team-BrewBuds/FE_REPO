import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'top_country.freezed.dart';

@freezed
class TopCountry with _$TopCountry {
  const factory TopCountry({
    required String country,
    required double percent,
  }) = _TopCountry;

}