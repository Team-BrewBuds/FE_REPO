import 'package:brew_buds/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'comments.freezed.dart';

part 'comments.g.dart';

@Freezed(toJson: false)
class Comment with _$Comment {
  const factory Comment({
    required int id,
    required User author,
    required String content,
    @JsonKey(name: 'like_cnt') required int likeCount,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'replies') required List<Comment> reComments,
    @JsonKey(name: 'is_user_liked') required bool isLiked,
  }) = _Comment;

  factory Comment.fromJson(Map<String, Object?> json) => _$CommentFromJson(json);
}
