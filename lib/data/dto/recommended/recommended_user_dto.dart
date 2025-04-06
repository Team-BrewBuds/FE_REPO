import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommended_user_dto.g.dart';

@JsonSerializable(createToJson: false)
class RecommendedUserDTO {
  @JsonKey(defaultValue: UserDTO.defaultUser)
  final UserDTO user;
  @JsonKey(name: 'follower_cnt', defaultValue: 0)
  final int followerCount;
  @JsonKey(includeToJson: false, includeFromJson: false)
  final bool isFollow = false;

  factory RecommendedUserDTO.fromJson(Map<String, dynamic> json) => _$RecommendedUserDTOFromJson(json);

  const RecommendedUserDTO({
    required this.user,
    required this.followerCount,
  });
}
