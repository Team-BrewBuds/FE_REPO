import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'top_flavor.freezed.dart';

@freezed
class TopFlavor with _$TopFlavor {
  const factory TopFlavor({
    required String flavor,
    required double percent,
  }) = _TopFlavor;
}