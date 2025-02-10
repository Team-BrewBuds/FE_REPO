import 'package:json_annotation/json_annotation.dart';

part 'social_login_dto.g.dart';

final class _User {
  final int id;
  final String email;

  const _User({
    required this.id,
    required this.email,
  });

  factory _User.fromJson(Map<String, dynamic> json) => _User(id: json['pk'] as int, email: json['email'] as String);
}

@JsonSerializable(createToJson: false)
class SocialLoginDTO {
  @JsonKey(name: 'access')
  final String accessToken;
  @JsonKey(name: 'refresh')
  final String refreshToken;
  @JsonKey(name: 'user', defaultValue: null)
  final _User? user;

  SocialLoginDTO(
    this.accessToken,
    this.refreshToken,
    this.user,
  );

  factory SocialLoginDTO.fromJson(Map<String, dynamic> json) => _$SocialLoginDTOFromJson(json);
}
