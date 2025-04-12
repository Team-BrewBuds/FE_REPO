import 'package:json_annotation/json_annotation.dart';

part 'account_info_dto.g.dart';

@JsonSerializable(createToJson: false)
class AccountInfoDTO {
  @JsonKey(name: '가입일', defaultValue: '')
  final String signUpAt;
  @JsonKey(name: '가입기간', defaultValue: '')
  final String signUpPeriod;
  @JsonKey(name: '로그인 유형', defaultValue: '')
  final String loginKind;
  @JsonKey(name: '성별', defaultValue: '')
  final String gender;
  @JsonKey(name: '태어난 연도', defaultValue: 0)
  final int yearOfBirth;

  factory AccountInfoDTO.fromJson(Map<String, dynamic> json) => _$AccountInfoDTOFromJson(json);

  const AccountInfoDTO({
    required this.signUpAt,
    required this.signUpPeriod,
    required this.loginKind,
    required this.gender,
    required this.yearOfBirth,
  });
}
