import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/profile/model/profile_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';

@Freezed(toJson: false, fromJson: false)
class Profile with _$Profile { //toJson, fromJson 수정필요 (Api Update후)
  const factory Profile({
    required int id,
    required String nickname,
    required String profileImageURI,
    required ProfileDetail detail,
    required int followingCount,
    required int followerCount,
    required int postCount,
    required bool isUserFollowing,
    required bool isUserBlocking,
  }) = _Profile;

  const Profile._();

  Map<String, dynamic> toJson() {
    final val = <String, dynamic>{
      'nickname': nickname,
    };

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        val[key] = value;
      }
    }

    writeNotNull('introduction', detail.introduction);
    writeNotNull('profile_link', detail.profileLink);
    writeNotNull('coffee_life', detail.coffeeLife?.map((e) => _coffeeLifeEnumMap[e]!).toList());
    writeNotNull('preferred_bean_taste', detail.preferredBeanTasted);
    writeNotNull('is_certificated', detail.isCertificated);

    return val;
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: (json['id'] as num).toInt(),
      nickname: json['nickname'] as String,
      profileImageURI: json['profile_image'] as String,
      detail: ProfileDetail(
        introduction: json['introduction'] as String,
        profileLink: json['profile_link'] ?? '',
        coffeeLife: _coffeeLifeFromJson(json['coffee_life'] as Map<String, dynamic>),
        preferredBeanTasted: null,
        isCertificated: null,
      ),
      followingCount: (json['following_cnt'] as num).toInt(),
      followerCount: (json['follower_cnt'] as num).toInt(),
      postCount: (json['post_cnt'] as num).toInt(),
      isUserFollowing: json['is_user_following'] as bool,
      isUserBlocking: json['is_user_blocking'] as bool,
    );
  }
}

const _coffeeLifeEnumMap = {
  CoffeeLife.cafeTour: 'cafe_tour',
  CoffeeLife.coffeeExtraction: 'coffee_extraction',
  CoffeeLife.coffeeStudy: 'coffee_study',
  CoffeeLife.cafeAlba: 'cafe_alba',
  CoffeeLife.cafeWork: 'cafe_work',
  CoffeeLife.cafeOperation: 'cafe_operation',
};

List<CoffeeLife> _coffeeLifeFromJson(Map<String, dynamic> json) {
  final List<CoffeeLife> result = [];
  json.forEach((key, value) {
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
