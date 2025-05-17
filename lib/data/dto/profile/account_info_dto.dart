import 'package:json_annotation/json_annotation.dart';

part 'account_info_dto.g.dart';

@JsonSerializable(createToJson: false)
class AccountInfoDTO {
  @JsonKey(name: 'joined_at', defaultValue: '')
  final String signUpAt;
  @JsonKey(name: 'joined_duration', defaultValue: 0)
  final int signUpPeriod;
  @JsonKey(name: 'login_type', defaultValue: '')
  final String loginKind;
  @JsonKey(name: 'gender', defaultValue: '')
  final String gender;
  @JsonKey(name: 'birth_year', defaultValue: 0)
  final int yearOfBirth;
  @JsonKey(name: 'email', defaultValue: '')
  final String email;

  factory AccountInfoDTO.fromJson(Map<String, dynamic> json) => _$AccountInfoDTOFromJson(json);

  const AccountInfoDTO({
    required this.signUpAt,
    required this.signUpPeriod,
    required this.loginKind,
    required this.gender,
    required this.yearOfBirth,
    required this.email,
  });
}
