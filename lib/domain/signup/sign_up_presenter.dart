import 'dart:convert';

import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/duplicated_nickname_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/login_repository.dart';
import 'package:brew_buds/domain/signup/model/sign_up_model.dart';
import 'package:brew_buds/exception/signup_exception.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/gender.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart';

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
  String _nickname = '';
  Gender? _gender;
  int? _yearOfBirth;
  final List<CoffeeLife> _coffeeLife = [];
  PreferredBeanTaste _preferredBeanTaste = PreferredBeanTaste.init();
  bool? _isCertificated;

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
      _isValidNickName() &&
      ((_yearOfBirthLength == 4 && _isValidYearOfBirth) || (_yearOfBirth == null));

  bool get isValidSecondPage => _coffeeLife.isNotEmpty;

  bool get isValidThirdPage => _isCertificated != null;

  bool get isValidLastPage =>
      (_preferredBeanTaste.body) != 0 &&
      (_preferredBeanTaste.sweetness) != 0 &&
      (_preferredBeanTaste.bitterness) != 0 &&
      (_preferredBeanTaste.acidity) != 0;

  String get nickName => _nickname;

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

  Gender? get currentGender => _gender;

  List<CoffeeLife> get selectedCoffeeLife => List.unmodifiable(_coffeeLife);

  bool? get isCertificated => _isCertificated;

  int get body => _preferredBeanTaste.body;

  int get acidity => _preferredBeanTaste.acidity;

  int get bitterness => _preferredBeanTaste.bitterness;

  int get sweetness => _preferredBeanTaste.sweetness;

  init() {
    _nicknameCheckDebouncer = Debouncer(
      const Duration(milliseconds: 300),
      initialValue: '',
      onChanged: (newNickname) {
        _checkNickname(newNickname);
      },
    );
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
      if ((nickName.length) < 2 || (nickName.length) > 12) {
        return Future.error(const InvalidNicknameException());
      }

      if (_isNicknameChecking) {
        return Future.error(const NicknameCheckingException());
      }

      if (_isDuplicatingNickname) {
        return Future.error(const DuplicateNicknameException());
      }
    } else if (index == 1) {
      if (_coffeeLife.isEmpty) {
        return Future.error(const EmptyCoffeeLifeSelectionException());
      }
    } else if (index == 2) {
      if (_isCertificated == null) {
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
    _coffeeLife.clear();
    notifyListeners();
  }

  resetCertificated() {
    _isCertificated = null;
    notifyListeners();
  }

  resetPreferredBeanTaste() {
    _preferredBeanTaste = const PreferredBeanTaste();
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
    _nickname = newNickName;
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
    _yearOfBirth = yearOfBirth;

    if (yearOfBirth != null && DateTime.now().year - yearOfBirth >= 14) {
      if (DateTime.now().year - yearOfBirth >= 14) {
        _isValidYearOfBirth = true;
      } else {
        _isValidYearOfBirth = false;
      }
    }
    _yearOfBirthLength = newYearOfBirth.length;

    notifyListeners();
  }

  onChangeGender(Gender newGender) {
    if (newGender == _gender) {
      _gender = null;
    } else {
      _gender = newGender;
    }
    notifyListeners();
  }

  onSelectCoffeeLife(CoffeeLife coffeeLife) {
    if (_coffeeLife.contains(coffeeLife)) {
      _coffeeLife.remove(coffeeLife);
    } else {
      _coffeeLife.add(coffeeLife);
    }
    notifyListeners();
  }

  onChangeCertificate(bool isCertificated) {
    if (_isCertificated == isCertificated) {
      _isCertificated = null;
    } else {
      _isCertificated = isCertificated;
    }
    notifyListeners();
  }

  onChangeBodyValue(int newValue) {
    if (_preferredBeanTaste.body == newValue) {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(body: 0);
    } else {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(body: newValue);
    }
    notifyListeners();
  }

  onChangeAcidityValue(int newValue) {
    if (_preferredBeanTaste.acidity == newValue) {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(acidity: 0);
    } else {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(acidity: newValue);
    }
    notifyListeners();
  }

  onChangeBitternessValue(int newValue) {
    if (_preferredBeanTaste.bitterness == newValue) {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(bitterness: 0);
    } else {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(bitterness: newValue);
    }
    notifyListeners();
  }

  onChangeSweetnessValue(int newValue) {
    if (_preferredBeanTaste.sweetness == newValue) {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(sweetness: 0);
    } else {
      _preferredBeanTaste = _preferredBeanTaste.copyWith(sweetness: newValue);
    }
    notifyListeners();
  }

  Future<void> register() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _loginRepository.registerAccount(
        model: SignUpModel(
          nickname: nickName,
          gender: _gender,
          birth: _yearOfBirth,
          coffeeLife: _coffeeLife.isNotEmpty ? _coffeeLife : null,
          preferredBeanTaste: _preferredBeanTaste.body != 0 &&
                  _preferredBeanTaste.bitterness != 0 &&
                  _preferredBeanTaste.acidity != 0 &&
                  _preferredBeanTaste.sweetness != 0
              ? _preferredBeanTaste
              : null,
          isCertificated: _isCertificated,
        ),
      );
      await _accountRepository.login(id: id, accessToken: accessToken, refreshToken: refreshToken);
    } catch (e) {
      throw const SignUpFailedException();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool _isValidNickName() {
    if (nickName.containsBadWords) {
      return false;
    }

    for (int codeUnit in nickName.codeUnits) {
      if (codeUnit >= 0x3131 && codeUnit <= 0x318E) {
        return false;
      }
    }
    return true;
  }
}
