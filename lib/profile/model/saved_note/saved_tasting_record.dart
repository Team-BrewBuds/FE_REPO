import 'package:brew_buds/profile/model/saved_note/saved_note.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_tasting_record.g.dart';

@JsonSerializable(createToJson: false)
class SavedTastingRecord with SavedNote {
  @JsonKey(name: 'tasted_record_id')
  final int id;
  @JsonKey(name: 'bean_name')
  final String beanName;
  @JsonKey(fromJson: _flavorFromJson)
  final List<String> flavor;
  @JsonKey(name: 'photo_url')
  final String imageUri;

  SavedTastingRecord(
    this.id,
    this.beanName,
    this.flavor,
    this.imageUri,
  );

  factory SavedTastingRecord.fromJson(Map<String, dynamic> json) => _$SavedTastingRecordFromJson(json);
}

List<String> _flavorFromJson(String json) {
  return json.split(',');
}