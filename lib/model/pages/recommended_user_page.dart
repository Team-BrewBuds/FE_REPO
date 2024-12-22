import 'package:brew_buds/model/recommended_category.dart';
import 'package:brew_buds/model/recommended_user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'recommended_user_page.freezed.dart';

part 'recommended_user_page.g.dart';

@Freezed(toJson: false)
class RecommendedUserPage with _$RecommendedUserPage {
  const factory RecommendedUserPage({
    required List<RecommendedUser> users,
    @JsonKey(unknownEnumValue: RecommendedCategory.cafeAlba) required RecommendedCategory category
  }) = _RecommendedUserPage;

  factory RecommendedUserPage.fromJson(Map<String, Object?> json) => _$RecommendedUserPageFromJson(json);
}