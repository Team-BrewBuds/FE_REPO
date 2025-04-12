import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bean_in_profile.freezed.dart';

@freezed
class BeanInProfile with _$BeanInProfile {
  const factory BeanInProfile({
    required int id,
    required String name,
    required String country,
    required int roastingPoint,
    required String rating,
    required int tastedRecordsCount,
  }) = _BeanInProfile;
}
