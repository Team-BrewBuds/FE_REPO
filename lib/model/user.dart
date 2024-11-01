import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user.freezed.dart';

part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    @JsonKey(defaultValue: 'Unknown') required String nickname,
    @JsonKey(name: 'profile_image', defaultValue: '') required String profileImageUri,
    @JsonKey(defaultValue: false) required bool isFollowed,
  }) = _Author;

  factory User.fromJson(Map<String, Object?> json) => _$UserFromJson(json);
}