import 'package:brew_buds/profile/model/bean_type.dart';
import 'package:brew_buds/profile/model/country.dart';
import 'package:brew_buds/profile/model/coffee_bean_filter.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final class FilterPresenter extends ChangeNotifier {
  final List<CoffeeBeanFilter> _filter = [];
  final Set<BeanType> _selectedTypes;
  final Set<Country> _selectedOrigins;
  SfRangeValues _ratingValues;
  bool _isDecaf;
  SfRangeValues _roastingPointValues;

  FilterPresenter({
    Set<BeanType>? selectedType,
    Set<Country>? selectedOrigins,
    SfRangeValues? ratingValues,
    bool isDecaf = false,
    SfRangeValues? roastingPointValues,
  })  : _selectedTypes = selectedType ?? <BeanType>{},
        _selectedOrigins = selectedOrigins ?? <Country>{},
        _ratingValues = ratingValues ?? const SfRangeValues(0.5, 5.0),
        _isDecaf = isDecaf,
        _roastingPointValues = roastingPointValues ?? const SfRangeValues(1, 5);

  List<CoffeeBeanFilter> get filter => _filter;

  bool get isAllSelectedType => _selectedTypes.length == 2;

  bool get isSelectedSingleOrigin => _selectedTypes.contains(BeanType.singleOrigin);

  bool get isSelectedBlend => _selectedTypes.contains(BeanType.blend);

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

  init() {
    _filter.addAll(
      _selectedTypes.map((type) => CoffeeBeanFilter.beanType(type)),
    );

    _filter.addAll(
      _selectedOrigins.map((origin) => CoffeeBeanFilter.country(origin)),
    );

    if (_isDecaf) {
      _filter.add(CoffeeBeanFilter.decaf(true));
    }

    if (_ratingValues.start != 0.5 && _ratingValues.end != 5.0) {
      _filter.add(CoffeeBeanFilter.rating(_ratingValues.start, _ratingValues.end));
    }

    if (_roastingPointValues.start != 1 && _roastingPointValues.end != 5.0) {
      _filter.add(CoffeeBeanFilter.roastingPoint(_roastingPointValues.start, _roastingPointValues.end));
    }
    notifyListeners();
  }

  removeAtFilter(int index) {
    final removedFilter = _filter.removeAt(index);
    switch (removedFilter) {
      case BeanTypeFilter():
        _selectedTypes.remove(removedFilter.type);
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

  onChangeAllTypeState() {
    if (_selectedTypes.length == 2) {
      _filter.removeWhere((element) => element is BeanTypeFilter);
      _selectedTypes.removeAll(BeanType.values);
    } else {
      _filter.addAll(BeanType.values.map((type) => CoffeeBeanFilter.beanType(type)));
      _selectedTypes.addAll(BeanType.values);
    }
    notifyListeners();
  }

  onChangeSingleOriginState() {
    if (_selectedTypes.contains(BeanType.singleOrigin)) {
      _filter.removeWhere((element) => element is BeanTypeFilter && element.type == BeanType.singleOrigin);
      _selectedTypes.remove(BeanType.singleOrigin);
    } else {
      _filter.add(CoffeeBeanFilter.beanType(BeanType.singleOrigin));
      _selectedTypes.add(BeanType.singleOrigin);
    }
    notifyListeners();
  }

  onChangeBlendState() {
    if (_selectedTypes.contains(BeanType.blend)) {
      _filter.removeWhere((element) => element is BeanTypeFilter && element.type == BeanType.blend);
      _selectedTypes.remove(BeanType.blend);
    } else {
      _filter.add(CoffeeBeanFilter.beanType(BeanType.blend));
      _selectedTypes.add(BeanType.blend);
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
