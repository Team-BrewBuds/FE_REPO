import 'package:brew_buds/model/user.dart';
import 'package:brew_buds/model/feeds/feed.dart';
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
    required User author,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'view_cnt') required int viewCount,
    @JsonKey(name: 'likes') required int likeCount,
    @JsonKey(name: 'comments') required int commentsCount,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
    @JsonKey(name: 'is_user_noted', defaultValue: false) required bool isSaved,
    @JsonKey(defaultValue: false) required bool isLeaveComment,
    @JsonKey(unknownEnumValue: PostSubject.normal) required PostSubject subject,
    required String title,
    @JsonKey(name: 'content') required String contents,
    required String tag,
    @JsonKey(name: 'photos', fromJson: _photosFromJson) @Default([]) List<String> imagesUri,
    @JsonKey(name: 'tasted_records') @Default([]) List<TastingRecordInPost> tastingRecords,
    @JsonKey(name: 'is_user_following') required bool isUserFollowing,
  }) = _Post;

  factory PostInFeed.fromJson(Map<String, Object?> json) => _$PostInFeedFromJson(json);
}

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
