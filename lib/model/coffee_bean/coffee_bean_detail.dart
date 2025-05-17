import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coffee_bean_detail.freezed.dart';

@freezed
class CoffeeBeanDetail with _$CoffeeBeanDetail {
  const factory CoffeeBeanDetail({
    required int id,
    required CoffeeBeanType type,
    required String name,
    required List<String> country,
    required String imagePath,
    required bool isDecaf,
    required double rating,
    required int recordCount,
    required List<TopFlavor> topFlavors,
    required List<String> flavors,
    required int body,
    required int acidity,
    required int bitterness,
    required int sweetness,
    String? region,
    String? extraction,
    int? roastPoint,
    String? process,
    bool? beverageType,
    String? roastery,
    String? variety,
    required bool isUserNoted,
    required bool isUserCreated,
    required bool isOfficial,
  }) = _CoffeeBeanDetail;
}
