import 'package:json_annotation/json_annotation.dart';

part 'user_dto.g.dart';

@JsonSerializable(createToJson: false)
class UserDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: 'Unknown')
  final String nickname;
  @JsonKey(name: 'profile_image', defaultValue: '')
  final String profileImageUrl;

  factory UserDTO.fromJson(Map<String, dynamic> json) => _$UserDTOFromJson(json);

  static UserDTO defaultUser() => const UserDTO(id: 0, nickname: 'Unknown', profileImageUrl: '');

  const UserDTO({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
  });
}
