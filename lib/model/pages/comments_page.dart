import 'package:brew_buds/model/comments.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'comments_page.freezed.dart';

part 'comments_page.g.dart';

@Freezed(toJson: false)
class CommentsPage with _$CommentsPage {
  const factory CommentsPage({
    @JsonKey(name: 'results') required List<Comment> comments,
    @JsonKey(name: 'next', fromJson: _hasNextFromJson) required bool hasNext,
  }) = _CommentsPage;

  const CommentsPage._();

  factory CommentsPage.initial() => const CommentsPage(comments: [], hasNext: true);

  factory CommentsPage.fromJson(Map<String, Object?> json) => _$CommentsPageFromJson(json);
}

bool _hasNextFromJson(dynamic json) => json != null;
