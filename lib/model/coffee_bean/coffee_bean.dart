import 'package:brew_buds/domain/coffee_note_tasting_record/model/coffee_bean_processing.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'coffee_bean.freezed.dart';

@freezed
class CoffeeBean with _$CoffeeBean {
  const factory CoffeeBean({
    required int id,
    CoffeeBeanType? type,
    String? name,
    String? region,
    List<String>? country,
    String? imageUri,
    bool? isDecaf,
    String? extraction,
    int? roastPoint,
    List<String>? process,
    bool? beverageType,
    String? roastery,
    String? variety,
    bool? isUserCreated,
    bool? isOfficial,
  }) = _CoffeeBean;

  factory CoffeeBean.empty() => const _CoffeeBean(id: 0);
}

String? _countryToJson(List<String>? country) {
  return country?.where((element) => element.isNotEmpty).join(',');
}

String? _nullableStringToJson(String? text) => (text ?? '').isEmpty ? null : text;
