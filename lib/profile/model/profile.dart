import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@Freezed(toJson: false)
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String nickname,
    @JsonKey(name: 'profile_image', defaultValue: '') required String profileImageURI,
    @JsonKey(defaultValue: null) required String? introduction,
    @JsonKey(name: 'profile_link', defaultValue: null) required String? profileLink,
    @JsonKey(name: 'coffee_life', fromJson: _coffeeLifeFromJson) required List<CoffeeLife> coffeeLife,
    @JsonKey(name: 'preferred_bean_taste', defaultValue: null) required PreferredBeanTaste? preferredBeanTaste,
    @JsonKey(name: 'is_certificated', defaultValue: null) required bool? isCertificated,
    @JsonKey(name: 'following_cnt',defaultValue: 0) required int followingCount,
    @JsonKey(name: 'follower_cnt',defaultValue: 0) required int followerCount,
    @JsonKey(name: 'post_cnt',defaultValue: 0) required int postCount,
    @JsonKey(name: 'is_user_following',defaultValue: null) required bool? isUserFollowing,
    @JsonKey(name: 'is_user_blocking',defaultValue: null) required bool? isUserBlocking,
  }) = _Profile;

  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);
}

List<CoffeeLife> _coffeeLifeFromJson(Map<String, dynamic>? json) {
  final List<CoffeeLife> result = [];
  json?.forEach((key, value) {
    if (value) {
      switch (key) {
        case 'cafe_tour':
          result.add(CoffeeLife.cafeTour);
          break;
        case 'coffee_extraction':
          result.add(CoffeeLife.coffeeExtraction);
          break;
        case 'coffee_study':
          result.add(CoffeeLife.coffeeStudy);
          break;
        case 'cafe_alba':
          result.add(CoffeeLife.cafeAlba);
          break;
        case 'cafe_work':
          result.add(CoffeeLife.cafeWork);
          break;
        case 'cafe_operation':
          result.add(CoffeeLife.cafeOperation);
          break;
      }
    }
  });
  return result;
}
