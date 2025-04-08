import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';
import 'package:brew_buds/model/coffee_bean/country.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

final class FilterPresenter extends Presenter {
  List<CoffeeBeanFilter> _filter;
  CoffeeBeanType? _selectedTypes;
  Set<Country> _selectedOrigins;
  SfRangeValues _ratingValues;
  bool _isDecaf;
  SfRangeValues _roastingPointValues;

  FilterPresenter({
    List<CoffeeBeanFilter> filter = const [],
  })  : _filter = filter,
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

  bool get isSelectedSingleOrigin => _selectedTypes == CoffeeBeanType.singleOrigin;

  bool get isSelectedBlend => _selectedTypes == CoffeeBeanType.blend;

  List<String> get selectedOrigins => _selectedOrigins.map((e) => e.toString()).toList();

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
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    final removedFilter = newFilter.removeAt(index);
    switch (removedFilter) {
      case BeanTypeFilter():
        _selectedTypes = null;
      case CountryFilter():
        _selectedOrigins = Set<Country>.from(_selectedOrigins)..remove(removedFilter.country);
      case RatingFilter():
        _ratingValues = const SfRangeValues(0.5, 5.0);
      case DecafFilter():
        _isDecaf = false;
      case RoastingPointFilter():
        _roastingPointValues = const SfRangeValues(1, 5);
    }
    _filter = newFilter;
    notifyListeners();
  }

  onChangeBeanType(CoffeeBeanType beanType) {
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    newFilter.removeWhere((element) => element is BeanTypeFilter);
    if (_selectedTypes == beanType) {
      _selectedTypes = null;
    } else {
      _selectedTypes = beanType;
      newFilter.add(CoffeeBeanFilter.beanType(beanType));
    }
    _filter = newFilter;
    notifyListeners();
  }

  onChangeStateOrigin(Country country) {
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    final newOrigins = Set<Country>.from(_selectedOrigins);
    if (newOrigins.contains(country)) {
      newFilter.removeWhere((element) => element is CountryFilter && element.country == country);
      newOrigins.remove(country);
    } else {
      newFilter.add(CoffeeBeanFilter.country(country));
      newOrigins.add(country);
    }
    _filter = newFilter;
    _selectedOrigins = newOrigins;
    notifyListeners();
  }

  bool isSelectedOrigin(Country country) {
    return _selectedOrigins.contains(country);
  }

  onChangeRatingValues({SfRangeValues values = const SfRangeValues(0.5, 5.0)}) {
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    newFilter.removeWhere((element) => element is RatingFilter);
    if (values.start != 0.5 || values.end != 5.0) {
      newFilter.add(CoffeeBeanFilter.rating(values.start, values.end));
    }
    _ratingValues = values;
    _filter = newFilter;
    notifyListeners();
  }

  onChangeIsDecaf() {
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    newFilter.removeWhere((element) => element is DecafFilter);
    _isDecaf = !_isDecaf;
    if (_isDecaf) {
      newFilter.add(CoffeeBeanFilter.decaf(true));
    }
    _filter = newFilter;
    notifyListeners();
  }

  onChangeRoastingPointValues({SfRangeValues values = const SfRangeValues(1, 5)}) {
    final newFilter = List<CoffeeBeanFilter>.from(_filter);
    newFilter.removeWhere((element) => element is RoastingPointFilter);
    if (values.start != 1 || values.end != 5) {
      newFilter.add(CoffeeBeanFilter.roastingPoint(values.start, values.end));
    }
    _roastingPointValues = values;
    _filter = newFilter;
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
