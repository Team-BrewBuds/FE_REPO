import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'follow_user.freezed.dart';

@freezed
class FollowUser with _$FollowUser {
  const factory FollowUser({
    required int id,
    required String nickname,
    required String profileImageUrl,
    required bool isFollowing,
  }) = _FollowUser;
}
