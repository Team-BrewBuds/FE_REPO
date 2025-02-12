import 'package:json_annotation/json_annotation.dart';

part 'login_result_dto.g.dart';

@JsonSerializable(createToJson: false)
class LoginResultDTO {
  @JsonKey(name: 'nickname_saved', defaultValue: false)
  final bool hasAccount;

  LoginResultDTO({
    required this.hasAccount,
  });

  factory LoginResultDTO.fromJson(Map<String, dynamic> json) => _$LoginResultDTOFromJson(json);
}
