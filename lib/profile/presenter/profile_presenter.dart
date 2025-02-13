import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/profile/model/bean_in_profile.dart';
import 'package:brew_buds/profile/model/coffee_bean_filter.dart';
import 'package:brew_buds/profile/model/SavedNote/saved_note.dart';
import 'package:brew_buds/profile/model/post_in_profile.dart';
import 'package:brew_buds/profile/model/profile.dart';
import 'package:brew_buds/profile/model/tasting_record_in_profile.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
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

enum BeanType {
  singleOrigin,
  blend;

  @override
  String toString() => switch (this) {
        BeanType.singleOrigin => 'single',
        // TODO: Handle this case.
        BeanType.blend => 'blend',
      };
}

final class _PageInfo {
  final int currentPage;

  _PageInfo(this.currentPage);
}

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

  int _tabIndex = 0;

  int _pageNo = 0;

  bool _hasNext = true;

  bool get hasNext => _hasNext;

  final List<TastingRecordInProfile> _tastingRecords = [];

  List<TastingRecordInProfile> get tastingRecords => _tastingRecords;

  final List<PostInProfile> _posts = [];

  List<PostInProfile> get posts => _posts;

  final List<BeanInProfile> _coffeeBeans = [];

  List<BeanInProfile> get coffeeBeans => _coffeeBeans;

  final List<SavedNote> _savedNotes = [];

  List<SavedNote> get saveNotes => _savedNotes;

  int get tabIndex => _tabIndex;

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

  int get id => _profile?.id ?? 0;

  String get nickname => _profile?.nickname ?? '';

  String get profileImageURI => _profile?.profileImageURI ?? '';

  String get tastingRecordCount => _countToString(_profile?.postCount ?? 0);

  String get followerCount => _countToString(_profile?.followerCount ?? 0);

  String get followingCount => _countToString(_profile?.followingCount ?? 0);

  bool get hasDetail => _profile?.introduction != null || _profile?.profileLink != null || _profile?.coffeeLife != null;

  String? get introduction => _profile?.introduction;

  String? get profileLink => _profile?.profileLink;

  List<String>? get coffeeLife => _profile?.coffeeLife?.map((coffeeLife) => coffeeLife.title).toList();

  ProfilePresenter({
    required ProfileRepository repository,
  }) : _repository = repository;

  initState() async {
    _profile = await _repository.fetchMyProfile();
    if (_profile?.id != null) {
      paginate(isPageChanged: true);
    }
    notifyListeners();
  }

  refresh() {}

  paginate({bool isPageChanged = false}) {
    if (isPageChanged) {
      _hasNext = true;
      _pageNo = 0;
      _tastingRecords.clear();
      _posts.clear();
      _coffeeBeans.clear();
      _savedNotes.clear();
    }

    _throttlePagination();
  }

  _throttlePagination() {
    if (_profile?.id != null && _hasNext) {
      if (tabIndex == 0) {
        _repository
            .fetchTastingRecordPage(
          userId: _profile!.id,
          pageNo: _pageNo + 1,
          //수정 필요 정렬 이상함(api)
          orderBy: null,
          beanType: _filter.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
          isDecaf: _filter.whereType<DecafFilter>().firstOrNull?.isDecaf,
          //국가 여러개?(api)
          country: _filter.whereType<CountryFilter>().firstOrNull?.country.toString(),
          roastingPointMin: _filter.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filter.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filter.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filter.whereType<RatingFilter>().firstOrNull?.end,
        )
            .then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _tastingRecords.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (tabIndex == 1) {
        _repository.fetchPostPage(userId: _profile!.id).then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _posts.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (tabIndex == 2) {
        _repository
            .fetchCoffeeBeanPage(
          userId: _profile!.id,
          pageNo: _pageNo + 1,
          //수정 필요 정렬 이상함(api)
          orderBy: null,
          beanType: _filter.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
          isDecaf: _filter.whereType<DecafFilter>().firstOrNull?.isDecaf,
          //국가 여러개?(api)
          country: _filter.whereType<CountryFilter>().firstOrNull?.country.toString(),
          roastingPointMin: _filter.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filter.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filter.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filter.whereType<RatingFilter>().firstOrNull?.end,
        )
            .then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _coffeeBeans.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else {
        _repository.fetchNotePage(userId: _profile!.id, pageNo: _pageNo + 1).then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _savedNotes.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      }
    }
  }

  onChangeTabIndex(int index) {
    if (_tabIndex == index) {
      refresh();
    } else {
      _tabIndex = index;
      paginate(isPageChanged: true);
    }
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

  bool checkScrollable() {
    if (_tabIndex == 0) {
      return tastingRecords.isNotEmpty;
    } else if (_tabIndex == 1) {
      return posts.isNotEmpty;
    } else if (_tabIndex == 2) {
      return coffeeBeans.isNotEmpty;
    } else {
      return saveNotes.isNotEmpty;
    }
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
