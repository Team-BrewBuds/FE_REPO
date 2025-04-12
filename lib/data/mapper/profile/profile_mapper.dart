import 'package:brew_buds/data/dto/profile/profile_dto.dart';
import 'package:brew_buds/data/mapper/common/coffee_life_mapper.dart';
import 'package:brew_buds/data/mapper/common/preferred_bean_taste_mapper.dart';
import 'package:brew_buds/model/profile/profile.dart';

extension ProfileMapper on ProfileDTO {
  Profile toDomain() {
    return Profile(
      id: id,
      nickname: nickname,
      profileImageUrl: profileImageUrl,
      introduction: introduction,
      profileLink: profileLink,
      coffeeLife: coffeeLife.map((e) => e.toDomain()).toList(),
      preferredBeanTaste: preferredBeanTaste.toDomain(),
      isCertificated: isCertificated,
      followingCount: followingCount,
      followerCount: followerCount,
      tastedRecordCnt: tastedRecordCnt,
      isUserFollowing: isUserFollowing,
      isUserBlocking: isUserBlocking,
    );
  }
}
