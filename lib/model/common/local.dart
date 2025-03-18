import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'local.freezed.dart';

@freezed
class Local with _$Local {
  const factory Local({
    required String name,
    required String distance,
    required String address,
  }) = _Local;
}