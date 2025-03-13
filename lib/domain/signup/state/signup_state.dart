import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/domain/signup/models/gender.dart';
import 'package:brew_buds/domain/signup/models/preferred_bean_taste.dart';

final class SignUpState {
  final String? nickName;
  final int? yearOfBirth;
  final Gender? gender;
  final List<CoffeeLife>? coffeeLifes;
  final bool? isCertificated;
  final PreferredBeanTaste? preferredBeanTaste;

  const SignUpState({
    this.nickName,
    this.yearOfBirth,
    this.gender,
    this.coffeeLifes,
    this.isCertificated,
    this.preferredBeanTaste,
  });

  SignUpState copyWith({
    String? nickName,
    int? yearOfBirth,
    Gender? gender,
    List<CoffeeLife>? coffeeLifes,
    bool? isCertificated,
    PreferredBeanTaste? preferredBeanTaste,
  }) {
    return SignUpState(
      nickName: nickName ?? this.nickName,
      yearOfBirth: yearOfBirth ?? this.yearOfBirth,
      gender: gender ?? this.gender,
      coffeeLifes: coffeeLifes ?? this.coffeeLifes,
      isCertificated: isCertificated ?? this.isCertificated,
      preferredBeanTaste: preferredBeanTaste ?? this.preferredBeanTaste,
    );
  }
}
