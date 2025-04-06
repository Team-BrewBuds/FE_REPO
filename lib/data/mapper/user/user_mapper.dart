import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:brew_buds/model/common/user.dart';

extension UserMapper on UserDTO {
  User toDomain() => User(
      id: id,
      nickname: nickname,
      profileImageUrl: profileImageUrl,
    );
}
