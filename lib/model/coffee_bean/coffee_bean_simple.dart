import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'coffee_bean_simple.freezed.dart';

@freezed
class CoffeeBeanSimple with _$CoffeeBeanSimple {
  const factory CoffeeBeanSimple({
    required int id,
    required String name,
  }) = _CoffeeBeanSimple;
}
