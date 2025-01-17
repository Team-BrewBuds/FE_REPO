import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/profile/model/coffee_bean_filter.dart';
import 'package:brew_buds/profile/model/profile.dart';
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
  final ProfileRepository _repository;
  Profile? _profile;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria.upToDate,
    SortCriteria.rating,
    SortCriteria.tastingRecords,
  ];
  int _currentSortCriteriaIndex = 0;
  SfRangeValues _ratingValues = SfRangeValues(0.5, 5.0);
  SfRangeValues _roastingPointValues = SfRangeValues(1, 5);

  final List<CoffeeBeanFilter> _filter = [];

  bool get hasFilter => _filter.isNotEmpty;

  bool get hasBeanTypeFilter => _filter.whereType<BeanTypeFilter>().isNotEmpty;

  bool get hasCountryFilter => _filter.whereType<CountryFilter>().isNotEmpty;

  bool get hasRatingFilter => _filter.whereType<RatingFilter>().isNotEmpty;

  bool get hasDecafFilter => _filter.whereType<DecafFilter>().isNotEmpty;

  bool get hasRoastingPointFilter => _filter.whereType<RoastingPointFilter>().isNotEmpty;

  List<SortCriteria> get sortCriteriaList => _sortCriteriaList;

  String get ratingString => '${_ratingValues.start}점 ~ ${_ratingValues.end}점';

  String get roastingPointString =>
      '${_toRoastingPointString(_roastingPointValues.start)} ~ ${_toRoastingPointString(_roastingPointValues.end)}';

  String get currentSortCriteria => _sortCriteriaList[_currentSortCriteriaIndex].buttonString;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  String get nickname => _profile?.nickname ?? '';

  String get profileImageURI => _profile?.profileImageURI ?? '';

  String get tastingRecordCount => _countToString(_profile?.postCount ?? 0);

  String get followerCount => _countToString(_profile?.followerCount ?? 0);

  String get followingCount => _countToString(_profile?.followingCount ?? 0);

  bool get hasDetail =>
      _profile?.detail.introduction != null ||
      _profile?.detail.profileLink != null ||
      _profile?.detail.coffeeLife != null;

  String? get introduction => _profile?.detail.introduction;

  String? get profileLink => _profile?.detail.profileLink;

  List<String>? get coffeeLife => _profile?.detail.coffeeLife?.map((coffeeLife) => coffeeLife.title).toList();

  ProfilePresenter({
    required ProfileRepository repository,
  }) : _repository = repository;

  initState() async {
    _profile = await _repository.fetchMyProfile();
    notifyListeners();
  }

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

  onChangeFilter(List<CoffeeBeanFilter> filter) {
    _filter.clear();
    _filter.addAll(filter);
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

  String _countToString(int count) {
    if (count == 0) {
      return '000';
    } else if (count >= 1000 && count < 1000000) {
      return '${count / 1000}.${count / 100}K';
    } else if (count >= 1000000 && count < 1000000000) {
      return '${count / 1000000}.${count / 100000}M';
    } else if (count >= 1000000000) {
      return '${count / 1000000000}.${count / 10000000}G';
    } else {
      return '$count';
    }
  }
}
