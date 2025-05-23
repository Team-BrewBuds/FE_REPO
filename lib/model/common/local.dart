import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'local.freezed.dart';

@freezed
class Local with _$Local {
  const factory Local({
    required String name,
    required String distance,
    required String address,
  }) = _Local;
}
