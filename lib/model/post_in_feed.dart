import 'package:brew_buds/model/author.dart';
import 'package:brew_buds/model/feed.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/tasting_record_in_post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post_in_feed.freezed.dart';

part 'post_in_feed.g.dart';

@freezed
class PostInFeed with _$PostInFeed, Feed {
  const factory PostInFeed({
    required int id,
    required Author author,
    @JsonKey(name: 'created_at', fromJson: DateTime.parse) required DateTime createdAt,
    @JsonKey(name: 'view_cnt') required int viewCount,
    @JsonKey(name: 'like_cnt') required int likeCount,
    @JsonKey(defaultValue: 0) required int commentsCount,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
    @JsonKey(defaultValue: false) required bool isLeaveComment,
    @JsonKey(defaultValue: false) required bool isSaved,
    @JsonKey(unknownEnumValue: PostSubject.normal) required PostSubject subject,
    required String title,
    @JsonKey(name: 'content') required String contents,
    required String tag,
    @JsonKey(name: 'photos', fromJson: _photosFromJson) @Default([]) List<String> imagesUri,
    @JsonKey(name: 'tasted_records') @Default([]) List<TastingRecordInPost> tastingRecords,
  }) = _Post;

  factory PostInFeed.fromJson(Map<String, Object?> json) => _$PostInFeedFromJson(json);
}

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
