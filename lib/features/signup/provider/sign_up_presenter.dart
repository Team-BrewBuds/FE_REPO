import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/result/result.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:brew_buds/features/signup/state/signup_state.dart';
import 'package:flutter/foundation.dart';

class SignUpPresenter with ChangeNotifier {
  final AccountRepository _accountRepository;
  final LoginRepository _loginRepository;
  SignUpState _state = const SignUpState();
  bool _isDuplicateNickname = false;

  bool _isLoading = false;

  SignUpPresenter({
    required AccountRepository accountRepository,
    required LoginRepository loginRepository,
  })  : _loginRepository = loginRepository,
        _accountRepository = accountRepository;

  bool get isLoading => _isLoading;

  String get nickName => _state.nickName ?? '';

  bool get isValidNicknameLength => (_state.nickName ?? '').length >= 2;

  bool get isDuplicateNickname => _isDuplicateNickname;

  bool _isValidYearOfBirth = false;

  bool get isValidYearOfBirth => _isValidYearOfBirth;

  Gender? get currentGender => _state.gender;

  List<CoffeeLife> get selectedCoffeeLife => _state.coffeeLifes ?? [];

  bool? get isCertificated => _state.isCertificated;

  int? get body => _state.preferredBeanTaste?.body;

  int? get acidity => _state.preferredBeanTaste?.acidity;

  int? get bitterness => _state.preferredBeanTaste?.bitterness;

  int? get sweetness => _state.preferredBeanTaste?.sweetness;

  init() {
    _state = const SignUpState();
    notifyListeners();
  }

  resetCoffeeLifes() {
    _state = _state.copyWith(coffeeLifes: []);
    notifyListeners();
  }

  resetCertificated() {
    _state = _state.copyWith(isCertificated: null);
    notifyListeners();
  }

  resetPreferredBeanTaste() {
    _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste.init());
    notifyListeners();
  }

  onChangeNickName(String newNickName) {
    _state = _state.copyWith(nickName: newNickName);
    if (_state.nickName != null && _state.nickName == '중복검사') {
      _isDuplicateNickname = true;
    } else {
      _isDuplicateNickname = false;
    }
    notifyListeners();
  }

  onChangeYearOfBirth(String newYearOfBirth) {
    _state = _state.copyWith(yearOfBirth: int.tryParse(newYearOfBirth));
    if (_state.yearOfBirth != null && DateTime.now().year - _state.yearOfBirth! >= 14) {
      _isValidYearOfBirth = true;
    } else {
      _isValidYearOfBirth = false;
    }

    notifyListeners();
  }

  onChangeGender(Gender newGender) {
    if (newGender == _state.gender) {
      _state = _state.copyWith(gender: null);
    } else {
      _state = _state.copyWith(gender: newGender);
    }
    notifyListeners();
  }

  onSelectCoffeeLife(CoffeeLife coffeeLife) {
    if (_state.coffeeLifes?.contains(coffeeLife) ?? false) {
      _state = _state.copyWith(coffeeLifes: _state.coffeeLifes?.where((c) => coffeeLife != c).toList());
    } else {
      _state = _state.copyWith(coffeeLifes: (_state.coffeeLifes ?? []) + [coffeeLife]);
    }
    notifyListeners();
  }

  onChangeCertificate(bool isCertificated) {
    if (_state.isCertificated == isCertificated) {
      _state = _state.copyWith(isCertificated: null);
    } else {
      _state = _state.copyWith(isCertificated: isCertificated);
    }
    notifyListeners();
  }

  onChangeBodyValue(int newValue) {
    if (_state.preferredBeanTaste == null) {
      _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste(body: newValue));
    } else {
      if (_state.preferredBeanTaste?.body == newValue) {
        _state = _state.copyWith(
          preferredBeanTaste: PreferredBeanTaste(
            acidity: _state.preferredBeanTaste?.acidity ?? 0,
            bitterness: _state.preferredBeanTaste?.bitterness ?? 0,
            sweetness: _state.preferredBeanTaste?.sweetness ?? 0,
          ),
        );
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(body: newValue));
      }
    }
    notifyListeners();
  }

  onChangeAcidityValue(int newValue) {
    if (_state.preferredBeanTaste == null) {
      _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste(acidity: newValue));
    } else {
      if (_state.preferredBeanTaste?.acidity == newValue) {
        _state = _state.copyWith(
          preferredBeanTaste: PreferredBeanTaste(
            body: _state.preferredBeanTaste?.body ?? 0,
            bitterness: _state.preferredBeanTaste?.bitterness ?? 0,
            sweetness: _state.preferredBeanTaste?.sweetness ?? 0,
          ),
        );
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(acidity: newValue));
      }
    }
    notifyListeners();
  }

  onChangeBitternessValue(int newValue) {
    if (_state.preferredBeanTaste == null) {
      _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste(bitterness: newValue));
    } else {
      if (_state.preferredBeanTaste?.bitterness == newValue) {
        _state = _state.copyWith(
          preferredBeanTaste: PreferredBeanTaste(
            body: _state.preferredBeanTaste?.body ?? 0,
            acidity: _state.preferredBeanTaste?.acidity ?? 0,
            sweetness: _state.preferredBeanTaste?.sweetness ?? 0,
          ),
        );
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(bitterness: newValue));
      }
    }
    notifyListeners();
  }

  onChangeSweetnessValue(int newValue) {
    if (_state.preferredBeanTaste == null) {
      _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste(sweetness: newValue));
    } else {
      if (_state.preferredBeanTaste?.sweetness == newValue) {
        _state = _state.copyWith(
          preferredBeanTaste: PreferredBeanTaste(
            body: _state.preferredBeanTaste?.body ?? 0,
            acidity: _state.preferredBeanTaste?.acidity ?? 0,
            bitterness: _state.preferredBeanTaste?.bitterness ?? 0,
          ),
        );
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: newValue));
      }
    }
    notifyListeners();
  }

  Future<void> register() async {
    _isLoading = true;
    notifyListeners();

    await _loginRepository.registerAccount(_state.toJson()).then(
          (result) {
            switch (result) {
              case Success<(String, String, int)>():
                _accountRepository.saveId(id: result.data.$3);
                _accountRepository.saveToken(
                  accessToken: result.data.$1,
                  refreshToken: result.data.$2,
                );
              case Error<(String, String, int)>():
                break;
            }
          },
        );

    _isLoading = false;
    notifyListeners();
  }
}
