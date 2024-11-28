import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:brew_buds/features/signup/state/signup_state.dart';
import 'package:flutter/foundation.dart';

class SignUpPresenter with ChangeNotifier {
  SignUpState _state = const SignUpState();

  bool get isNotEmptyNickName => _state.nickName?.isNotEmpty ?? false;

  bool _isValidNickName = false;

  bool get isValidNickName => _isValidNickName;

  bool get isNotEmptyYearOfBirth => _state.yearOfBirth != null;

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

  onChangeNickName(String newNickName) {
    _state = _state.copyWith(nickName: newNickName);
    notifyListeners();
  }

  checkNickName() {
    if ((_state.nickName?.length ?? 0) >= 2) {
      _isValidNickName = true;
    } else {
      _isValidNickName = false;
    }
    notifyListeners();
  }

  String? validatedNickname(String? nickName) {
    if (nickName == null) {
      return null;
    } else if (nickName.isEmpty) {
      return null;
    } else if (nickName.length < 2) {
      return '2자 이상 입력해 주세요.';
    } else {
      return null;
    }
  }

  onChangeYearOfBirth(String newYearOfBirth) {
    _state = _state.copyWith(yearOfBirth: int.tryParse(newYearOfBirth));
    notifyListeners();
  }

  String? validatedYearOfBirth(String? yearOfBirth) {
    if (yearOfBirth != null && yearOfBirth.length == 4) {
      final int? year = int.tryParse(yearOfBirth);
      if (year == null) {
        return null;
      } else if (((DateTime.now().year - year).abs() + 1) < 14) {
        return '만 14세 미만은 가입할 수 없어요.';
      } else {
        return null;
      }
    } else {
      return null;
    }
  }

  checkYearOfBirth() {
    if (_state.yearOfBirth != null && DateTime.now().year - _state.yearOfBirth! + 1 >= 12) {
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
            acidity: _state.preferredBeanTaste?.acidity,
            bitterness: _state.preferredBeanTaste?.bitterness,
            sweetness: _state.preferredBeanTaste?.sweetness,
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
            body: _state.preferredBeanTaste?.body,
            bitterness: _state.preferredBeanTaste?.bitterness,
            sweetness: _state.preferredBeanTaste?.sweetness,
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
            body: _state.preferredBeanTaste?.body,
            acidity: _state.preferredBeanTaste?.acidity,
            sweetness: _state.preferredBeanTaste?.sweetness,
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
            body: _state.preferredBeanTaste?.body,
            acidity: _state.preferredBeanTaste?.acidity,
            bitterness: _state.preferredBeanTaste?.bitterness,
          ),
        );
      } else {
        _state = _state.copyWith(preferredBeanTaste: _state.preferredBeanTaste?.copyWith(sweetness: newValue));
      }
    }
    notifyListeners();
  }
}
