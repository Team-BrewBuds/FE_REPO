import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String nickname,
    required String profileImageUrl,
    required String? introduction,
    required String? profileLink,
    required List<CoffeeLife> coffeeLife,
    required PreferredBeanTaste preferredBeanTaste,
    required bool? isCertificated,
    required int followingCount,
    required int followerCount,
    required int tastedRecordCnt,
    required bool? isUserFollowing,
    required bool? isUserBlocking,
  }) = _Profile;
}
