import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/model/profile/account_info.dart';
import 'package:flutter/foundation.dart';

final class AccountInfoPresenter extends ChangeNotifier {
  final AccountRepository _accountRepository = AccountRepository.instance;
  final ProfileRepository _profileRepository = ProfileRepository.instance;
  AccountInfo? _accountInfo;

  String get signUpInfo => '$signUpAt ($signUpPeriod)';

  String get signUpAt => _accountInfo?.signUpAt ?? '';

  String get signUpPeriod => _accountInfo?.signUpPeriod ?? '';

  String get loginKind => _accountInfo?.loginKind ?? '';

  String get gender => _accountInfo?.gender ?? '';

  int get yearOfBirth => _accountInfo?.yearOfBirth ?? 0;

  initState() {
    _fetchInfo();
  }

  _fetchInfo() async {
    final id = _accountRepository.id;
    if (id != null) {
      _accountInfo = await _profileRepository.fetchInfo(id: id);
      notifyListeners();
    }
  }
}
