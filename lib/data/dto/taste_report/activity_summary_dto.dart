import 'package:json_annotation/json_annotation.dart';

part 'activity_summary_dto.g.dart';

@JsonSerializable(createToJson: false)
class ActivitySummaryDTO {
  @JsonKey(name: 'tasted_record_cnt', defaultValue: 0)
  final int tastedRecordCount;
  @JsonKey(name: 'post_cnt', defaultValue: 0)
  final int postCount;
  @JsonKey(name: 'saved_notes_cnt', defaultValue: 0)
  final int savedNoteCount;
  @JsonKey(name: 'saved_beans_cnt', defaultValue: 0)
  final int savedBeanCount;

  factory ActivitySummaryDTO.fromJson(Map<String, dynamic> json) => _$ActivitySummaryDTOFromJson(json);

  const ActivitySummaryDTO({
    required this.tastedRecordCount,
    required this.postCount,
    required this.savedNoteCount,
    required this.savedBeanCount,
  });
}
