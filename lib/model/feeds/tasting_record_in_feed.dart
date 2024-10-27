import 'package:brew_buds/model/user.dart';
import 'package:brew_buds/model/feeds/feed.dart';

import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasting_record_in_feed.freezed.dart';

part 'tasting_record_in_feed.g.dart';

@freezed
class TastingRecordInFeed with _$TastingRecordInFeed, Feed {
  const factory TastingRecordInFeed({
    required int id,
    required User author,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse) required DateTime createdAt,
    @JsonKey(name: 'view_cnt') required int viewCount,
    @JsonKey(name: 'like_cnt') required int likeCount,
    @JsonKey(defaultValue: 0) required int commentsCount,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
    @JsonKey(defaultValue: false) required bool isLeaveComment,
    @JsonKey(defaultValue: false) required bool isSaved,
    @JsonKey(name: 'bean_name') required String beanName,
    @JsonKey(name: 'bean_type') required String beanType,
    @JsonKey(name: 'content') required String contents,
    @JsonKey(name: 'star_rating') required double rating,
    @JsonKey(name: 'flavor', fromJson: _flavorFromJson) required List<String> flavors,
    required String tag,
    @JsonKey(name: 'photos', fromJson: _photosFromJson) @Default([]) List<String> imagesUri,
  }) = _TastingRecord;

  const TastingRecordInFeed._();

  String get thumbnailUri => imagesUri.firstOrNull ?? '';

  factory TastingRecordInFeed.fromJson(Map<String, Object?> json) => _$TastingRecordInFeedFromJson(json);

}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
