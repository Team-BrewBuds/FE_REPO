import 'package:brew_buds/model/common/user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'comments.freezed.dart';

@Freezed(equal: false)
class Comment with _$Comment {
  const factory Comment({
    required int id,
    required User author,
    required String content,
    required int likeCount,
    required String createdAt,
    required List<Comment> reComments,
    required bool isLiked,
    @Default(null) int? parentId,
  }) = _Comment;

  const Comment._();

  @override
  bool operator ==(Object other) {
    return other is Comment && other.id == id;
  }

  @override
  int get hashCode => Object.hash(runtimeType, id);
}
