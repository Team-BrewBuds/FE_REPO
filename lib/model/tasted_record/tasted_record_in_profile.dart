import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasted_record_in_profile.freezed.dart';

@freezed
class TastedRecordInProfile with _$TastedRecordInProfile {
  const factory TastedRecordInProfile({
    required int id,
    required String beanName,
    required double rating,
    required String imageUrl,
    required int likeCount,
  }) = _TastedRecordInProfile;
}
