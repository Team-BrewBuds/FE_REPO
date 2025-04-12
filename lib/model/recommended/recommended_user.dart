import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_user.freezed.dart';

@freezed
class RecommendedUser with _$RecommendedUser {
  const factory RecommendedUser({
    required int id,
    required String nickname,
    required String profileImageUrl,
    required int followerCount,
    @Default(false) bool isFollow,
  }) = _RecommendedUser;
}
