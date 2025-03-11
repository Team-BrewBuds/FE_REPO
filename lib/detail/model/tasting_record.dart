import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/detail/model/tasting_review.dart';
import 'package:brew_buds/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasting_record.freezed.dart';

part 'tasting_record.g.dart';

@freezed
class TastingRecord with _$TastingRecord {
  const factory TastingRecord({
    required int id,
    required User author,
    required CoffeeBean bean,
    @JsonKey(name: 'taste_review') required TastingReview tastingReview,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'view_cnt') int? viewCount,
    @JsonKey(name: 'likes') required int likeCount,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
    @JsonKey(name: 'content') required String contents,
    String? tag,
    @JsonKey(name: 'photos', fromJson: _photosFromJson) required List<String> imagesUri,
  }) = _TastingRecord;

  factory TastingRecord.fromJson(Map<String, Object?> json) => _$TastingRecordFromJson(json);
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
