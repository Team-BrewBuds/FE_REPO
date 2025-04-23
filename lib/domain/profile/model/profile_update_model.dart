import 'package:brew_buds/data/mapper/common/preferred_bean_taste_mapper.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';

class ProfileUpdateModel {
  final String? nickname;
  final UserDetail userDetail;

  ProfileUpdateModel({
    this.nickname,
    String? introduction,
    String? profileLink,
    List<CoffeeLife>? coffeeLife,
    PreferredBeanTaste? preferredBeanTaste,
    bool? isCertificated,
  }) : userDetail = UserDetail._(
          introduction: introduction,
          profileLink: profileLink,
          coffeeLife: coffeeLife,
          preferredBeanTaste: preferredBeanTaste,
          isCertificated: isCertificated,
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    if (nickname != null) {
      json['nickname'] = nickname;
    }

    final userDetailJson = userDetail._toJson();

    if (userDetailJson.isNotEmpty) {
      json['user_detail'] = userDetailJson;
    }

    return json;
  }
}

final class UserDetail {
  final String? introduction;
  final String? profileLink;
  final List<CoffeeLife>? coffeeLife;
  final PreferredBeanTaste? preferredBeanTaste;
  final bool? isCertificated;

  UserDetail._({
    required this.introduction,
    required this.profileLink,
    required this.coffeeLife,
    required this.preferredBeanTaste,
    required this.isCertificated,
  });

  Map<String, dynamic> _toJson() {
    final Map<String, dynamic> json = {};

    if (introduction != null) {
      json['introduction'] = introduction;
    }

    if (profileLink != null) {
      json['profile_link'] = profileLink;
    }

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
