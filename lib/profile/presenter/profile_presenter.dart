import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

enum SortCriteria {
  upToDate,
  rating,
  tastingRecords;

  String get buttonString => switch (this) {
        SortCriteria.upToDate => '최근저장순',
        SortCriteria.rating => '별점높은순',
        SortCriteria.tastingRecords => '시음기록순',
      };

  String get columnString => switch (this) {
        SortCriteria.upToDate => '최근 찜한 순',
        SortCriteria.rating => '평균 별점 높은 순',
        SortCriteria.tastingRecords => '시음 기록 많은 순',
      };
}

enum BeanType { singleOrigin, blend }

enum BeanOrigin { none }

class ProfilePresenter extends ChangeNotifier {
  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria.upToDate,
    SortCriteria.rating,
    SortCriteria.tastingRecords,
  ];
  int _currentSortCriteriaIndex = 0;
  SfRangeValues _ratingValues = SfRangeValues(0.5, 5.0);
  SfRangeValues _roastingPointValues = SfRangeValues(1, 5);

  List<SortCriteria> get sortCriteriaList => _sortCriteriaList;

  String get ratingString => '${_ratingValues.start}점 ~ ${_ratingValues.end}점';

  String get roastingPointString =>
      '${_toRoastingPointString(_roastingPointValues.start)} ~ ${_toRoastingPointString(_roastingPointValues.end)}';

  String get currentSortCriteria => _sortCriteriaList[_currentSortCriteriaIndex].buttonString;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    notifyListeners();
  }

  onChangeRatingValues(SfRangeValues values) {
    _ratingValues = values;
    notifyListeners();
  }

  onChangeRoastingPointValues(SfRangeValues values) {
    _roastingPointValues = values;
    notifyListeners();
  }

  String _toRoastingPointString(double value) {
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
