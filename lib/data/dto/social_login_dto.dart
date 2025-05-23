import 'package:json_annotation/json_annotation.dart';

part 'social_login_dto.g.dart';

final class User {
  final int id;
  final String email;

  const User({
    required this.id,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(id: json['pk'] as int, email: json['email'] as String);
}

@JsonSerializable(createToJson: false)
class SocialLoginDTO {
  @JsonKey(name: 'access')
  final String accessToken;
  @JsonKey(name: 'refresh')
  final String refreshToken;
  @JsonKey(name: 'user')
  final User user;

  SocialLoginDTO(
    this.accessToken,
    this.refreshToken,
    this.user,
  );

  factory SocialLoginDTO.fromJson(Map<String, dynamic> json) => _$SocialLoginDTOFromJson(json);
}
