import 'package:brew_buds/features/signup/models/SignUp.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/state/signup_state.dart';
import 'package:flutter/foundation.dart';

class SignUpPresenter with ChangeNotifier {
  SignUpState _state = const SignUpState();
  final SignUp _signUp = SignUp();
  String _token = '';
  String _refreshToken = '';
  String _platform = '';

  SignUp get signUpData => _signUp;

  String get token => _token;

  String get refreshToken => _refreshToken;

  String get platform => _platform;

  bool get isNotEmptyNickName => _state.nickName?.isNotEmpty ?? false;

  bool _isValidNickName = false;

  bool get isValidNickName => _isValidNickName;

  bool get isNotEmptyYearOfBirth => _state.yearOfBirth != null;

  bool _isValidYearOfBirth = false;

  bool get isValidYearOfBirth => _isValidYearOfBirth;

  Gender? get currentGender => _state.gender;

  init() {
    _state = const SignUpState();
    notifyListeners();
  }

  Future<void> setToken(String token, String? refreshToken, String platform) async {
    _token = token;
    _refreshToken = refreshToken!;
    _platform = platform;

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

  //조건 모두 만족시 다음 버튼 활성화
  bool ableCondition(String nickName, String age, int gender) {
    if (age.isNotEmpty && nickName.length > 1 && gender != -1) {
      notifyListeners();
      return true;
    } else {
      notifyListeners();
      return false;
    }
  }

  void getUserData(String nickname, String year, int gender) {
    _signUp.nickname = nickname;
    _signUp.birth_year = year;
    if (gender == 0) {
      _signUp.gender = '여';
    } else if (gender == 1) {
      _signUp.gender = '남';
    }

    notifyListeners();
  }

  void getCoffeeLife(List<String> coffee_life) {
    _signUp.coffee_life = coffee_life;

    notifyListeners();
  }

  void getIsCertificated(bool is_certificated) {
    _signUp.is_certificated = is_certificated;
    notifyListeners();
  }

  void getPreferredBeanTaste(Map<String, dynamic> preferred_bean_taste) {
    _signUp.preferred_bean_taste = preferred_bean_taste;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return _signUp.toJson();
  }
}
