
import 'package:brew_buds/domain/coffee_note_tasting_record/model/taste_review.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasting_write_state.g.dart';

@JsonSerializable(explicitToJson: true, createFactory: false)
class TastingWriteState {
  final String content;
  @JsonKey(name: 'is_private')
  final bool isPrivate;
  @JsonKey(includeIfNull: false, toJson: _nullableStringToJson)
  final String? tag;
  final CoffeeBean bean;
  @JsonKey(name: 'taste_review')
  final TasteReview tasteReview;
  final List<int> photos;


  Map<String, dynamic> toJson() => _$TastingWriteStateToJson(this);

  const TastingWriteState({
    required this.content,
    this.isPrivate = false,
    this.tag,
    required this.bean,
    required this.tasteReview,
    required this.photos,
  });
}

String? _nullableStringToJson(String? text) => (text ?? '').isEmpty ? null : text;