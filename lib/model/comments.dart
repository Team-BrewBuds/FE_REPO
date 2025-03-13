import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'comments.freezed.dart';

@freezed
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
}
