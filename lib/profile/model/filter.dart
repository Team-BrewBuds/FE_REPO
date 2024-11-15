import 'package:brew_buds/profile/model/bean_type.dart';
import 'package:brew_buds/profile/model/country.dart';

sealed class Filter {
  String get text;

  factory Filter.beanType(BeanType beanType) = BeanTypeFilter;

  factory Filter.country(Country country) = CountryFilter;

  factory Filter.rating(double start, double end) = RatingFilter;

  factory Filter.decaf(bool isDecaf) = DecafFilter;

  factory Filter.roastingPoint(double start, double end) = RoastingPointFilter;
}

final class BeanTypeFilter implements Filter {
  final BeanType type;

  BeanTypeFilter(this.type);

  @override
  String get text => type.toString();
}

final class CountryFilter implements Filter {
  final Country country;

  CountryFilter(this.country);

  @override
  String get text => country.toString();
}

final class RatingFilter implements Filter {
  final double start;
  final double end;

  RatingFilter(this.start, this.end);

  @override
  String get text => start == end ? '$start점' : '$start점 ~ $end점';
}

final class DecafFilter implements Filter {
  final bool isDecaf;

  DecafFilter(this.isDecaf);

  @override
  String get text => isDecaf ? '디카페인' : '';
}

final class RoastingPointFilter implements Filter {
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
