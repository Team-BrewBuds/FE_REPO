import 'package:brew_buds/data/dto/recommended/recommended_user_dto.dart';
import 'package:brew_buds/model/recommended/recommended_user.dart';

extension RecommendedUserMapper on RecommendedUserDTO {
  RecommendedUser toDomain() => RecommendedUser(
      id: user.id,
      nickname: user.nickname,
      profileImageUrl: user.profileImageUrl,
      followerCount: followerCount,
    );
}
