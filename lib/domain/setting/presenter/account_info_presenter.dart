import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/model/profile/account_info.dart';

final class AccountInfoPresenter extends Presenter {
  final AccountRepository _accountRepository = AccountRepository.instance;
  final ProfileRepository _profileRepository = ProfileRepository.instance;
  AccountInfo? _accountInfo;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get signUpInfo => signUpPeriod.isNotEmpty ? '$signUpAt ($signUpPeriod)' : signUpAt;

  String get signUpAt => _accountInfo?.signUpAt ?? '';

  String get signUpPeriod => _accountInfo?.signUpPeriod ?? '';

  String get loginKind => _accountInfo?.loginKind ?? '';

  String get gender => _accountInfo?.gender ?? '';

  int get yearOfBirth => _accountInfo?.yearOfBirth ?? 0;

  String get email => _accountInfo?.email ?? '';

  initState() {
    _fetchInfo();
  }

  _fetchInfo() async {
    _isLoading = true;
    notifyListeners();

    final id = _accountRepository.id;
    if (id != null) {
      _accountInfo = await _profileRepository.fetchInfo(id: id);
    }

    _isLoading = false;
    notifyListeners();
  }
}
