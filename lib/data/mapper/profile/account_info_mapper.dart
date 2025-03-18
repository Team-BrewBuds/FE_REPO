import 'package:brew_buds/data/dto/profile/account_info_dto.dart';
import 'package:brew_buds/model/profile/account_info.dart';

extension AccountInfoMapper on AccountInfoDTO {
  AccountInfo toDomain() => AccountInfo(
        signUpAt: signUpAt,
        signUpPeriod: signUpPeriod,
        loginKind: loginKind,
        gender: gender,
        yearOfBirth: yearOfBirth,
      );
}
