import 'package:brew_buds/model/user.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/tasting_record_in_post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post.freezed.dart';

part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required int id,
    required User author,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'view_cnt') required int viewCount,
    @JsonKey(name: 'likes') required int likeCount,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
    @JsonKey(unknownEnumValue: PostSubject.normal) required PostSubject subject,
    required String title,
    @JsonKey(name: 'content') required String contents,
    required String tag,
    @JsonKey(name: 'photos', fromJson: _photosFromJson) @Default([]) List<String> imagesUri,
    @JsonKey(name: 'tasted_records') @Default([]) List<TastingRecordInPost> tastingRecords,
  }) = _Post;

  factory Post.fromJson(Map<String, Object?> json) => _$PostFromJson(json);
}

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}