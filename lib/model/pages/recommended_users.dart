import 'package:brew_buds/model/recommended_category.dart';
import 'package:brew_buds/model/recommended_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recommended_users.freezed.dart';

part 'recommended_users.g.dart';

@Freezed(toJson: false)
class RecommendedUsers with _$RecommendedUsers {
  const factory RecommendedUsers({
    required List<RecommendedUser> users,
    @JsonKey(unknownEnumValue: RecommendedCategory.cafeAlba) required RecommendedCategory category
  }) = _RecommendedUsers;

  factory RecommendedUsers.fromJson(Map<String, Object?> json) => _$RecommendedUsersFromJson(json);
}