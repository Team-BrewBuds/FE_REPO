import 'package:brew_buds/model/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recommended_user.freezed.dart';

part 'recommended_user.g.dart';

@Freezed(toJson: false)
class RecommendedUser with _$RecommendedUser {
  const factory RecommendedUser({
    required User user,
    @JsonKey(name: 'follower_cnt') required int followerCount,
    @JsonKey(includeToJson: false, includeFromJson: false) @Default(false) bool isFollow,
  }) = _RecommendedUser;

  factory RecommendedUser.fromJson(Map<String, Object?> json) => _$RecommendedUserFromJson(json);
}
