import 'package:brew_buds/filter/model/bean_type.dart';
import 'package:brew_buds/filter/model/country.dart';

sealed class CoffeeBeanFilter {
  String get text;

  factory CoffeeBeanFilter.beanType(BeanType beanType) = BeanTypeFilter;

  factory CoffeeBeanFilter.country(Country country) = CountryFilter;

  factory CoffeeBeanFilter.rating(double start, double end) = RatingFilter;

  factory CoffeeBeanFilter.decaf(bool isDecaf) = DecafFilter;

  factory CoffeeBeanFilter.roastingPoint(double start, double end) = RoastingPointFilter;
}

final class BeanTypeFilter implements CoffeeBeanFilter {
  final BeanType type;

  BeanTypeFilter(this.type);

  @override
  String get text => type.toString();
}

final class CountryFilter implements CoffeeBeanFilter {
  final Country country;

  CountryFilter(this.country);

  @override
  String get text => country.toString();
}

final class RatingFilter implements CoffeeBeanFilter {
  final double start;
  final double end;

  RatingFilter(this.start, this.end);

  @override
  String get text => start == end ? '$start점' : '$start점 ~ $end점';
}

final class DecafFilter implements CoffeeBeanFilter {
  final bool isDecaf;

  DecafFilter(this.isDecaf);

  @override
  String get text => isDecaf ? '디카페인' : '';
}

final class RoastingPointFilter implements CoffeeBeanFilter {
  final double start;
  final double end;

  RoastingPointFilter(this.start, this.end);

  @override
  String get text => start == end
      ? _toRoastingPointString(start)
      : '${_toRoastingPointString(start)} ~ ${_toRoastingPointString(end)}';

  String _toRoastingPointString(num value) {
    switch (value) {
      case 1:
        return '라이트';
      case 2:
        return '라이트 미디엄';
      case 3:
        return '미디엄';
      case 4:
        return '미디엄 다크';
      case 5:
        return '다크';
      default:
        return '';
    }
  }
}
