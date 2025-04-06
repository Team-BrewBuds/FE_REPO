import 'package:brew_buds/data/dto/taste_report/activity_summary_dto.dart';
import 'package:brew_buds/model/taste_report/activity_summary.dart';

extension ActivitySummaryMapper on ActivitySummaryDTO {
  ActivitySummary toDomain() => ActivitySummary(
        tastedRecordCount: tastedRecordCount,
        postCount: postCount,
        savedNoteCount: savedNoteCount,
        savedBeanCount: savedBeanCount,
      );
}
