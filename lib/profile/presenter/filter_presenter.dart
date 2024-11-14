import 'package:brew_buds/profile/model/bean_type.dart';
import 'package:brew_buds/profile/model/country.dart';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final class FilterPresenter extends ChangeNotifier {
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
        _ratingValues = ratingValues ?? SfRangeValues(0.5, 5.0),
        _isDecaf = isDecaf,
        _roastingPointValues = roastingPointValues ?? SfRangeValues(1, 5);

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

  onChangeAllTypeState() {
    if (_selectedTypes.length == 2) {
      _selectedTypes.removeAll(BeanType.values);
    } else {
      _selectedTypes.addAll(BeanType.values);
    }
    notifyListeners();
  }

  onChangeSingleOriginState() {
    if (_selectedTypes.contains(BeanType.singleOrigin)) {
      _selectedTypes.remove(BeanType.singleOrigin);
    } else {
      _selectedTypes.add(BeanType.singleOrigin);
    }
    notifyListeners();
  }

  onChangeBlendState() {
    if (_selectedTypes.contains(BeanType.blend)) {
      _selectedTypes.remove(BeanType.blend);
    } else {
      _selectedTypes.remove(BeanType.blend);
    }
    notifyListeners();
  }

  onChangeStateOrigin(Country country) {
    if (_selectedOrigins.contains(country)) {
      _selectedOrigins.remove(country);
    } else {
      _selectedOrigins.add(country);
    }
    notifyListeners();
  }

  bool isSelectedOrigin(Country country) {
    return _selectedOrigins.contains(country);
  }

  onChangeRatingValues(SfRangeValues values) {
    _ratingValues = values;
    notifyListeners();
  }

  onChangeIsDecaf() {
    _isDecaf = !_isDecaf;
    notifyListeners();
  }

  onChangeRoastingPointValues(SfRangeValues values) {
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
