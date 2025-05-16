import 'package:brew_buds/data/mapper/common/preferred_bean_taste_mapper.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/gender.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';

class SignUpModel {
  final String nickname;
  final Gender? gender;
  final int? birth;
  final UserDetail userDetail;

  SignUpModel({
    required this.nickname,
    this.gender,
    this.birth,
    List<CoffeeLife>? coffeeLife,
    PreferredBeanTaste? preferredBeanTaste,
    bool? isCertificated,
  }) : userDetail = UserDetail._(
          coffeeLife: coffeeLife,
          preferredBeanTaste: preferredBeanTaste,
          isCertificated: isCertificated,
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    json['nickname'] = nickname;

    if (gender != null) {
      json['gender'] = _genderToJson(gender);
    }

    if (birth != null) {
      json['birth'] = birth;
    }

    final userDetailJson = userDetail._toJson();

    if (userDetailJson.isNotEmpty) {
      json['detail'] = userDetailJson;
    }

    return json;
  }
}

final class UserDetail {
  final List<CoffeeLife>? coffeeLife;
  final PreferredBeanTaste? preferredBeanTaste;
  final bool? isCertificated;

  UserDetail._({
    required this.coffeeLife,
    required this.preferredBeanTaste,
    required this.isCertificated,
  });

  Map<String, dynamic> _toJson() {
    final Map<String, dynamic> json = {};

    if (coffeeLife?.isNotEmpty ?? false) {
      json['coffee_life'] = _coffeeLifeToJson(coffeeLife);
    }

    if (preferredBeanTaste != null) {
      json['preferred_bean_taste'] = preferredBeanTaste?.toJson();
    }

    if (isCertificated != null) {
      json['is_certificated'] = isCertificated;
    }

    return json;
  }
}

Map<String, dynamic>? _coffeeLifeToJson(List<CoffeeLife>? coffeeLife) {
  if (coffeeLife == null) return null;
  return {
    'cafe_alba': coffeeLife.contains(CoffeeLife.cafeAlba),
    'cafe_tour': coffeeLife.contains(CoffeeLife.cafeTour),
    'cafe_work': coffeeLife.contains(CoffeeLife.cafeWork),
    'coffee_study': coffeeLife.contains(CoffeeLife.coffeeStudy),
    'cafe_operation': coffeeLife.contains(CoffeeLife.cafeOperation),
    'coffee_extraction': coffeeLife.contains(CoffeeLife.coffeeExtraction),
  };
}

String? _genderToJson(Gender? gender) {
  switch (gender) {
    case null:
      return null;
    case Gender.male:
      return '남';
    case Gender.female:
      return '여';
  }
}
