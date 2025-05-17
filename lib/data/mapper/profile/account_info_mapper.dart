import 'package:brew_buds/data/dto/profile/account_info_dto.dart';
import 'package:brew_buds/model/profile/account_info.dart';

extension AccountInfoMapper on AccountInfoDTO {
  AccountInfo toDomain() => AccountInfo(
        signUpAt: signUpAt,
        signUpPeriod: signUpPeriod != 0 ? '$signUpPeriod일' : '',
        loginKind: loginKind,
        gender: gender,
        yearOfBirth: yearOfBirth,
        email: email,
      );
}
