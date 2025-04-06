import 'package:brew_buds/data/dto/user/follow_user_dto.dart';
import 'package:brew_buds/domain/follow_list/model/follow_user.dart';

extension FollowUserMapper on FollowUserDTO {
  FollowUser toDomain() {
    return FollowUser(
      id: user.id,
      nickname: user.nickname,
      profileImageUrl: user.profileImageUrl,
      isFollowing: isFollowing,
    );
  }
}
