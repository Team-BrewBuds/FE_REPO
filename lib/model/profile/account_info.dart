import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'account_info.freezed.dart';

@freezed
class AccountInfo with _$AccountInfo {
  const factory AccountInfo({
    required String signUpAt,
    required String signUpPeriod,
    required String loginKind,
    required String gender,
    required int yearOfBirth,
  }) = _AccountInfo;
}
