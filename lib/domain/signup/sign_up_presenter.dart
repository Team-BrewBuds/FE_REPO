import 'dart:convert';

import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/duplicated_nickname_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/data/repository/notification_repository.dart';
import 'package:brew_buds/domain/signup/state/signup_state.dart';
import 'package:brew_buds/exception/signup_exception.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/gender.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

typedef NicknameValidState = ({
  bool isChangeNickname,
  bool hasNickname,
  bool isValidNicknameLength,
  bool isValidNickname,
  bool isDuplicatingNickname,
  bool isNicknameChecking,
});
typedef YearOfBirthValidState = ({int yearOfBirthLength, bool isValidYearOfBirth});

class SignUpPresenter extends Presenter {
  final AccountRepository _accountRepository = AccountRepository.instance;
  final LoginRepository _loginRepository = LoginRepository.instance;
  final DuplicatedNicknameApi _duplicatedNicknameApi =
      DuplicatedNicknameApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));
  late final Debouncer<String> _nicknameCheckDebouncer;
  SignUpState _state = const SignUpState();
  bool _isChangeNickname = false;
  bool _isDuplicatingNickname = false;
  bool _isNicknameChecking = false;
  bool _isLoading = false;

  String get accessToken => AccountRepository.instance.accessTokenInMemory;

  String get refreshToken => AccountRepository.instance.refreshTokenInMemory;

  int get id => AccountRepository.instance.idInMemory ?? 0;

  bool get isLoading => _isLoading;

  bool get isValidFirstPage =>
      nickName.length >= 2 &&
      nickName.length <= 12 &&
      !_isNicknameChecking &&
      !_isDuplicatingNickname &&
      _yearOfBirthLength == 4 &&
      _isValidYearOfBirth &&
      _state.gender != null &&
      _isValidNickName();

  bool get isValidSecondPage => _state.coffeeLifes?.isNotEmpty ?? false;

  bool get isValidThirdPage => _state.isCertificated != null;

  bool get isValidLastPage =>
      (_state.preferredBeanTaste?.body ?? 0) != 0 &&
      (_state.preferredBeanTaste?.sweetness ?? 0) != 0 &&
      (_state.preferredBeanTaste?.bitterness ?? 0) != 0 &&
      (_state.preferredBeanTaste?.acidity ?? 0) != 0;

  String get nickName => _state.nickName ?? '';

  NicknameValidState get nicknameValidState => (
        isChangeNickname: _isChangeNickname,
        hasNickname: nickName.isNotEmpty,
        isValidNicknameLength: nickName.length >= 2 && nickName.length <= 12,
        isValidNickname: _isValidNickName(),
        isDuplicatingNickname: _isDuplicatingNickname,
        isNicknameChecking: _isNicknameChecking,
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

  init() {
    _nicknameCheckDebouncer = Debouncer(
      const Duration(milliseconds: 300),
      initialValue: '',
      onChanged: (newNickname) {
        _checkNickname(newNickname);
      },
    );
    _state = const SignUpState();
    notifyListeners();
  }

  Future<void> onSkip(int index) {
    if (index == 1 || index == 2) {
      return Future.value();
    } else {
      return register();
    }
  }

  Future<void> isValidAt(int index) {
    if (index == 0) {
      if ((_state.nickName?.length ?? 0) < 2 || (_state.nickName?.length ?? 0) > 12) {
        return Future.error(const InvalidNicknameException());
      }

      if (_isNicknameChecking) {
        return Future.error(const NicknameCheckingException());
      }

      if (_isDuplicatingNickname) {
        return Future.error(const DuplicateNicknameException());
      }

      if (_yearOfBirthLength != 4 && !_isValidYearOfBirth) {
        return Future.error(const InvalidBirthYearException());
      }

      if (_state.gender == null) {
        return Future.error(const InvalidGenderSelectionException());
      }
    } else if (index == 1) {
      if (_state.coffeeLifes?.isEmpty ?? true) {
        return Future.error(const EmptyCoffeeLifeSelectionException());
      }
    } else if (index == 2) {
      if (_state.isCertificated == null) {
        return Future.error(const InvalidCertificateSelectionException());
      }
    } else if (index == 3) {
      if (!isValidLastPage) {
        return Future.error(const EmptyCoffeePreferenceSelectionException());
      } else {
        return register();
      }
    }

    return Future.value();
  }

  resetCoffeeLifes() {
    _state = _state.copyWith(coffeeLifes: []);
    notifyListeners();
  }

  resetCertificated() {
    _state = _state.copyWithoutIsCertificated();
    notifyListeners();
  }

  resetPreferredBeanTaste() {
    _state = _state.copyWith(preferredBeanTaste: PreferredBeanTaste.init());
    notifyListeners();
  }

  bool canNext(int index) {
    if (index == 0) {
      return isValidFirstPage;
    } else if (index == 1) {
      return isValidSecondPage;
    } else if (index == 2) {
      return isValidThirdPage;
    } else {
      return isValidLastPage;
    }
  }

  onChangeNickName(String newNickName) {
    if (!_isChangeNickname) {
      _isChangeNickname = true;
    }
    _state = _state.copyWith(nickName: newNickName);
    _nicknameCheckDebouncer.setValue(newNickName);
    notifyListeners();
  }

  _checkNickname(String newNickname) async {
    if (!_isNicknameChecking && newNickname.length >= 2) {
      _isNicknameChecking = true;
      notifyListeners();
      _isDuplicatingNickname = await _duplicatedNicknameApi.checkNickname(nickname: newNickname).then((value) {
        try {
          final json = jsonDecode(value) as Map<String, dynamic>;
          return !(json['is_available'] as bool? ?? false);
        } catch (e) {
          return true;
        }
      }).onError((error, stackTrace) => true);
      _isNicknameChecking = false;
      notifyListeners();
    }
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
      _state = _state.copyWithoutGender();
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(body: 0));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(acidity: 0));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(bitterness: 0));
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
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: 0));
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: newValue));
      }
    }
    notifyListeners();
  }

  Future<void> register() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginRepository.registerAccount(state: _state);
      await NotificationRepository.instance.registerToken(accessToken);
      await _accountRepository.login(id: id, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      throw const SignUpFailedException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidNickName() {
    for (int codeUnit in nickName.codeUnits) {
      if (codeUnit >= 0x3131 && codeUnit <= 0x318E) {
        return false;
      }
    }
    return true;
  }
}
