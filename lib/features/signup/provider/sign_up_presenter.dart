import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:brew_buds/features/signup/state/signup_state.dart';
import 'package:flutter/foundation.dart';

typedef NicknameValidState = ({int nickNameLength, bool isValidNickname});
typedef YearOfBirthValidState = ({int yearOfBirthLength, bool isValidYearOfBirth});

class SignUpPresenter with ChangeNotifier {
  final AccountRepository _accountRepository = AccountRepository.instance;
  final LoginRepository _loginRepository = LoginRepository.instance;
  late String _accessToken;
  late String _refreshToken;
  late int _id;
  SignUpState _state = const SignUpState();

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  bool get isValidFirstPage =>
      _isValidNickname &&
      (_state.nickName?.length ?? 0) > 2 &&
      _yearOfBirthLength == 4 &&
      _isValidYearOfBirth &&
      _state.gender != null;

  bool get isValidSecondPage => _state.coffeeLifes?.isNotEmpty ?? false;

  bool get isValidThirdPage => _state.isCertificated != null;

  String get nickName => _state.nickName ?? '';

  bool _isValidNickname = false;

  NicknameValidState get nicknameValidState => (
        nickNameLength: (_state.nickName ?? '').length,
        isValidNickname: _isValidNickname,
      );

  int _yearOfBirthLength = 0;

  bool _isValidYearOfBirth = false;

  YearOfBirthValidState get yearOfBirthValidState => (
        yearOfBirthLength: _yearOfBirthLength,
        isValidYearOfBirth: _isValidYearOfBirth,
      );

  Gender? get currentGender => _state.gender;

  List<CoffeeLife> get selectedCoffeeLife => _state.coffeeLifes ?? [];

  bool? get isCertificated => _state.isCertificated;

  int get body => _state.preferredBeanTaste?.body ?? 0;

  int get acidity => _state.preferredBeanTaste?.acidity ?? 0;

  int get bitterness => _state.preferredBeanTaste?.bitterness ?? 0;

  int get sweetness => _state.preferredBeanTaste?.sweetness ?? 0;

  init(String accessToken, String refreshToken, int id) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _id = id;
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
    if (_state.nickName == '중복검사') {
      _isValidNickname = false;
    } else {
      _isValidNickname = true;
    }
    notifyListeners();
  }

  onChangeYearOfBirth(String newYearOfBirth) {
    final yearOfBirth = int.tryParse(newYearOfBirth);
    _state = _state.copyWith(yearOfBirth: yearOfBirth);
    if (yearOfBirth != null && DateTime.now().year - yearOfBirth >= 14) {
      _isValidYearOfBirth = true;
    } else {
      _isValidYearOfBirth = false;
    }
    _yearOfBirthLength = newYearOfBirth.length;

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
      _state = _state.copyWith(coffeeLifes: List.from(_state.coffeeLifes ?? [])..remove(coffeeLife));
    } else {
      _state = _state.copyWith(coffeeLifes: List.from(_state.coffeeLifes ?? [])..add(coffeeLife));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(body: null));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(acidity: null));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(bitterness: null));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: null));
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: newValue));
      }
    }
    notifyListeners();
  }

  Future<bool> register() async {
    _isLoading = true;
    notifyListeners();

    final result = await _loginRepository
        .registerAccount(
          accessToken: _accessToken,
          refreshToken: _refreshToken,
          data: _state.toJson(),
        )
        .onError((error, stackTrace) => false);

    if (result) {
      _accountRepository.saveId(id: _id);
      await _accountRepository.saveToken(accessToken: _accessToken, refreshToken: _refreshToken);

      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
