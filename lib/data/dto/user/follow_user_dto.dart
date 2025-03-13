import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow_user_dto.g.dart';

@JsonSerializable(createToJson: false)
class FollowUserDTO {
  @JsonKey(defaultValue: UserDTO.defaultUser)
  final UserDTO user;
  @JsonKey(name: 'is_following')
  final bool isFollowing;

  factory FollowUserDTO.fromJson(Map<String, dynamic> json) => _$FollowUserDTOFromJson(json);

  const FollowUserDTO({
    required this.user,
    required this.isFollowing,
  });
}
