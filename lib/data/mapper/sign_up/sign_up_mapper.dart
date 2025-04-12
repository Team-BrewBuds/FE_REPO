import 'package:brew_buds/data/mapper/common/coffee_life_mapper.dart';
import 'package:brew_buds/data/mapper/sign_up/preferred_bean_taste_mapper.dart';
import 'package:brew_buds/domain/signup/state/signup_state.dart';
import 'package:brew_buds/model/common/gender.dart';

extension SignUpStateToJson on SignUpState {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }

    writeNotNull('nickname', nickName);
    writeNotNull('birth_year', yearOfBirth);
    writeNotNull('gender', _genderEnumMap[gender]);
    writeNotNull('coffee_life', coffeeLifes?.map((e) => e.toJson()).toList());
    writeNotNull('is_certificated', isCertificated);
    writeNotNull('preferred_bean_taste', preferredBeanTaste?.toJson());

    return json;
  }
}

const Map<Gender, String> _genderEnumMap = {
  Gender.male: '남',
  Gender.female: '여',
};
