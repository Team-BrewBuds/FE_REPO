import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'activity_summary.freezed.dart';

@freezed
class ActivitySummary with _$ActivitySummary {
  const factory ActivitySummary({
    required int tastedRecordCount,
    required int postCount,
    required int savedNoteCount,
    required int savedBeanCount,
  }) = _ActivitySummary;
}