import 'package:brew_buds/features/signup/models/SignUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignUpPresenter with ChangeNotifier {
  final SignUp _signUp = SignUp();
  String? _nickNameError;
  String? _ageError;
  FlutterSecureStorage _storage = FlutterSecureStorage();
  String _token ='';
  String  _refreshToken ='';
  String  _platform  ='';

  SignUp get signUpData => _signUp;
  String? get nickNameError => _nickNameError;
  String? get ageError => _ageError;



  String get token => _token;
  String get refreshToken => _refreshToken;
  String get platform => _platform;


 Future<void> setToken(String token, String ?refreshToken , String platform)async {
   _token = token;
   _refreshToken = refreshToken!;
   _platform = platform;

   notifyListeners();

 }


  void validateNickname(String value) {
    bool val;
    if (value.length < 2) {
      _nickNameError = '2 ~ 12자 이내만 가능해요.';
      val = false;
    } else {
      _nickNameError = null;
      val = true;
    }
    validateAge(val);
  }

  void updateState(String value) {
    bool val = _isUnderAge(value);
    validateAge(val);
  }

  bool _isUnderAge(String yearStr) {
    int? birthYear = int.tryParse(yearStr);
    int currentYear = DateTime.now().year;

    if (yearStr.length != 4) return false;
    if (birthYear == null) return false;
    int age = currentYear - birthYear;
    return age < 15;
  }

  void validateAge(bool value) {
    if (!value) {
      _ageError = null;
    } else {
      _ageError = '만 14세 미만은 가입할 수 없어요.';
    }
  }

  //조건 모두 만족시 다음 버튼 활성화
  bool ableCondition(String nickName, String age, int gender) {
    if (_ageError == null && age.isNotEmpty && nickName.length > 1 && gender != -1) {
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
    _signUp.toJson();

    return _signUp.toJson();
  }
}
