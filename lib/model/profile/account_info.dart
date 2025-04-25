import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_info.freezed.dart';

@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required String signUpAt,
    required String signUpPeriod,
    required String loginKind,
    required String gender,
    required int yearOfBirth,
    required String email,
  }) = _AccountInfo;
}
