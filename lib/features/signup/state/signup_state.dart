import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/features/signup/models/gender.dart';
import 'package:brew_buds/features/signup/models/preferred_bean_taste.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'signup_state.freezed.dart';

part 'signup_state.g.dart';

@Freezed(fromJson: false, toJson: true)
class SignUpState with _$SignUpState {
  @JsonSerializable(createFactory: false, explicitToJson: true)
  const factory SignUpState({
    @JsonKey(name: 'nickname', disallowNullValue: true) String? nickName,
    @JsonKey(name: 'birth_year', disallowNullValue: true) int? yearOfBirth,
    @JsonKey(defaultValue: Gender.female, disallowNullValue: true) Gender? gender,
    @JsonKey(name: 'coffee_life', includeIfNull: false) List<CoffeeLife>? coffeeLifes,
    @JsonKey(name: 'is_certificated', includeIfNull: false) bool? isCertificated,
    @JsonKey(name: 'preferred_bean_taste', includeIfNull: false) PreferredBeanTaste? preferredBeanTaste,
  }) = _SignUpState;
}
