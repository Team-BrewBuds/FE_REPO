import 'package:brew_buds/filter/model/bean_type.dart';
import 'package:brew_buds/filter/model/country.dart';
import 'package:brew_buds/filter/model/coffee_bean_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final class FilterPresenter extends ChangeNotifier {
  final List<CoffeeBeanFilter> _filter;
  BeanType? _selectedTypes;
  final Set<Country> _selectedOrigins;
  SfRangeValues _ratingValues;
  bool _isDecaf;
  SfRangeValues _roastingPointValues;

  FilterPresenter({
    List<CoffeeBeanFilter> filter = const [],
  })  : _filter = List.from(filter),
        _selectedTypes = filter.whereType<BeanTypeFilter>().firstOrNull?.type,
        _selectedOrigins = filter.whereType<CountryFilter>().map((e) => e.country).toSet(),
        _ratingValues = SfRangeValues(
          filter.whereType<RatingFilter>().firstOrNull?.start ?? 0.5,
          filter.whereType<RatingFilter>().firstOrNull?.end ?? 5.0,
        ),
        _isDecaf = filter.whereType<DecafFilter>().firstOrNull?.isDecaf ?? false,
        _roastingPointValues = SfRangeValues(
          filter.whereType<RoastingPointFilter>().firstOrNull?.start ?? 1,
          filter.whereType<RoastingPointFilter>().firstOrNull?.end ?? 5,
        );

  List<CoffeeBeanFilter> get filter => _filter;

  bool get isSelectedSingleOrigin => _selectedTypes == BeanType.singleOrigin;

  bool get isSelectedBlend => _selectedTypes == BeanType.blend;

  List<String> get selectedOrigins => _selectedOrigins.map((e) => e.toString()).toList();

  List<Continent> get continent => Continent.values;

  bool get isDecaf => _isDecaf;

  SfRangeValues get ratingValues => _ratingValues;

  String get ratingString => _ratingValues.start == _ratingValues.end
      ? '${_ratingValues.start}점'
      : '${_ratingValues.start}점 ~ ${_ratingValues.end}점';

  SfRangeValues get roastingPointValues => _roastingPointValues;

  String get roastingPointString => _roastingPointValues.start == _roastingPointValues.end
      ? toRoastingPointString(_roastingPointValues.start)
      : '${toRoastingPointString(_roastingPointValues.start)} ~ ${toRoastingPointString(_roastingPointValues.end)}';

  init() {}

  removeAtFilter(int index) {
    final removedFilter = _filter.removeAt(index);
    switch (removedFilter) {
      case BeanTypeFilter():
        _selectedTypes = null;
      case CountryFilter():
        _selectedOrigins.remove(removedFilter.country);
      case RatingFilter():
        _ratingValues = const SfRangeValues(0.5, 5.0);
      case DecafFilter():
        _isDecaf = false;
      case RoastingPointFilter():
        _roastingPointValues = const SfRangeValues(1, 5);
    }
    notifyListeners();
  }

  onChangeBeanType(BeanType beanType) {
    _filter.removeWhere((element) => element is BeanTypeFilter);
    if (_selectedTypes == beanType) {
      _selectedTypes = null;
    } else {
      _selectedTypes = beanType;
      _filter.add(CoffeeBeanFilter.beanType(beanType));
    }
    notifyListeners();
  }

  onChangeStateOrigin(Country country) {
    if (_selectedOrigins.contains(country)) {
      _filter.removeWhere((element) => element is CountryFilter && element.country == country);
      _selectedOrigins.remove(country);
    } else {
      _filter.add(CoffeeBeanFilter.country(country));
      _selectedOrigins.add(country);
    }
    notifyListeners();
  }

  bool isSelectedOrigin(Country country) {
    return _selectedOrigins.contains(country);
  }

  onChangeRatingValues({SfRangeValues values = const SfRangeValues(0.5, 5.0)}) {
    _filter.removeWhere((element) => element is RatingFilter);
    if (values.start != 0.5 || values.end != 5.0) {
      _filter.add(CoffeeBeanFilter.rating(values.start, values.end));
    }
    _ratingValues = values;
    notifyListeners();
  }

  onChangeIsDecaf() {
    _filter.removeWhere((element) => element is DecafFilter);
    _isDecaf = !_isDecaf;
    if (_isDecaf) {
      _filter.add(CoffeeBeanFilter.decaf(true));
    }
    notifyListeners();
  }

  onChangeRoastingPointValues({SfRangeValues values = const SfRangeValues(1, 5)}) {
    _filter.removeWhere((element) => element is RoastingPointFilter);
    if (values.start != 1 || values.end != 5) {
      _filter.add(CoffeeBeanFilter.roastingPoint(values.start, values.end));
    }
    _roastingPointValues = values;
    notifyListeners();
  }

  String toRoastingPointString(num value) {
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
