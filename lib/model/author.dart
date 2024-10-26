import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'author.freezed.dart';

part 'author.g.dart';

@freezed
class Author with _$Author {
  const factory Author({
    required int id,
    @JsonKey(defaultValue: 'Unknown') required String nickname,
    @JsonKey(name: 'profile_image', defaultValue: '') required String profileImageUri,
  }) = _Author;

  factory Author.fromJson(Map<String, Object?> json) => _$AuthorFromJson(json);
}