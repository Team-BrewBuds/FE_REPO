import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'profile.freezed.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    required int id,
    required String nickname,
    required String profileImageUrl,
    required String? introduction,
    required String? profileLink,
    required List<CoffeeLife> coffeeLife,
    required PreferredBeanTaste preferredBeanTaste,
    required bool? isCertificated,
    required int followingCount,
    required int followerCount,
    required int postCount,
    required bool? isUserFollowing,
    required bool? isUserBlocking,
  }) = _Profile;
}
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> jsonMap = {};
//   jsonMap['nickname'] = '"$nickname"';
//
//   final detail = _toJsonDetail();
//   if (detail.isNotEmpty) jsonMap['user_detail'] = detail;
//
//   return jsonMap;
// }
//
// Map<String, dynamic> _toJsonDetail() {
//   final Map<String, dynamic> jsonMap = {};
//
//   void writeNotNull(String key, dynamic value) {
//     if (value != null) {
//       jsonMap[key] = value;
//     }
//   }
//
//   writeNotNull('introduction', introduction);
//   writeNotNull('profile_link', profileLink);
//   writeNotNull('coffee_life', _coffeeLifeToJson(coffeeLife));
//   writeNotNull('preferred_bean_taste', _preferredBeanTasteToJson(preferredBeanTaste));
//   writeNotNull('is_certificated', isCertificated);
//
//   return jsonMap;
// }
//
// List<CoffeeLife> _coffeeLifeFromJson(Map<String, dynamic> json) {
//   final List<CoffeeLife> result = [];
//   for (var coffeeLife in CoffeeLife.values) {
//     final data = json[coffeeLife.toJson()] as bool;
//     if (data) {
//       result.add(coffeeLife);
//     }
//   }
//   return result;
// }
//
// PreferredBeanTaste _preferredBeanTasteFromJson(dynamic jsonString) {
//   try {
//     print(jsonString);
//     final valueList = (jsonString as String).split(',').map((e) => int.parse(e.substring(e.length - 1))).toList();
//     return PreferredBeanTaste(
//       body: valueList[0],
//       acidity: valueList[1],
//       sweetness: valueList[2],
//       bitterness: valueList[3],
//     );
//   } catch (_) {
//     return const PreferredBeanTaste();
//   }
// }
//
// String? _coffeeLifeToJson(List<CoffeeLife> coffeeLife) {
//   if (coffeeLife.isEmpty) {
//     return null;
//   } else {
//     return '"cafe_tour: ${coffeeLife.contains(CoffeeLife.cafeTour)}, coffee_extraction: ${coffeeLife.contains(CoffeeLife.coffeeExtraction)}, coffee_study: ${coffeeLife.contains(CoffeeLife.coffeeStudy)}, cafe_alba: ${coffeeLife.contains(CoffeeLife.cafeAlba)}, cafe_work: ${coffeeLife.contains(CoffeeLife.cafeWork)}, cafe_operation: ${coffeeLife.contains(CoffeeLife.cafeOperation)}"';
//   }
// }
//
// String? _preferredBeanTasteToJson(PreferredBeanTaste preferredBeanTaste) {
//   return '"body: ${preferredBeanTaste.body}, acidity: ${preferredBeanTaste.acidity}, sweetness: ${preferredBeanTaste.sweetness}, bitterness: ${preferredBeanTaste.bitterness}"';
// }
