import 'package:json_annotation/json_annotation.dart';

part 'search_user_dto.g.dart';

@JsonSerializable(createToJson: false)
class SearchUserDTO {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'nickname', defaultValue: '')
  final String nickname;
  @JsonKey(name: 'email', defaultValue: '')
  final String email;
  @JsonKey(name: 'profile_image', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'record_cnt', defaultValue: 0)
  final int tastingRecordCount;
  @JsonKey(name: 'follower_cnt', defaultValue: 0)
  final int followerCount;

  factory SearchUserDTO.fromJson(Map<String, dynamic> json) => _$SearchUserDTOFromJson(json);

  const SearchUserDTO({
    required this.id,
    required this.nickname,
    required this.email,
    required this.imageUrl,
    required this.tastingRecordCount,
    required this.followerCount,
  });
}
