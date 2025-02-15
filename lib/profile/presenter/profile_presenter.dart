import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/filter/model/search_sort_criteria.dart';
import 'package:brew_buds/profile/model/in_profile/bean_in_profile.dart';
import 'package:brew_buds/profile/model/saved_note/saved_note.dart';
import 'package:brew_buds/profile/model/in_profile/post_in_profile.dart';
import 'package:brew_buds/profile/model/profile.dart';
import 'package:brew_buds/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:flutter/foundation.dart';

class ProfilePresenter extends ChangeNotifier {
  final ProfileRepository repository;
  Profile? profile;

  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria.upToDate,
    SortCriteria.rating,
    SortCriteria.tastingRecords,
  ];

  int _currentSortCriteriaIndex = 0;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  final List<CoffeeBeanFilter> _filters = [];

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

  List<CoffeeBeanFilter> get filters => _filters;

  bool get hasFilter => _filters.isNotEmpty;

  bool get hasBeanTypeFilter => _filters.whereType<BeanTypeFilter>().isNotEmpty;

  bool get hasCountryFilter => _filters.whereType<CountryFilter>().isNotEmpty;

  bool get hasRatingFilter => _filters.whereType<RatingFilter>().isNotEmpty;

  bool get hasDecafFilter => _filters.whereType<DecafFilter>().isNotEmpty;

  bool get hasRoastingPointFilter => _filters.whereType<RoastingPointFilter>().isNotEmpty;

  List<SortCriteria> get sortCriteriaList => _sortCriteriaList;

  int get id => profile?.id ?? 0;

  String get nickname => profile?.nickname ?? '';

  String get profileImageURI => profile?.profileImageURI ?? '';

  String get tastingRecordCount => _countToString(profile?.postCount ?? 0);

  String get followerCount => _countToString(profile?.followerCount ?? 0);

  String get followingCount => _countToString(profile?.followingCount ?? 0);

  bool get hasDetail =>
      profile?.introduction != null || profile?.profileLink != null || (profile?.coffeeLife.isNotEmpty ?? false);

  String? get introduction => profile?.introduction;

  String? get profileLink => profile?.profileLink;

  List<String>? get coffeeLife => profile?.coffeeLife.map((coffeeLife) => coffeeLife.title).toList();

  bool get isFollow => profile?.isUserFollowing ?? false;

  ProfilePresenter({required this.repository});

  initState() async {
    profile = await fetchProfile();
    if (profile?.id != null) {
      paginate(isPageChanged: true);
    }
    notifyListeners();
  }

  refresh() {}

  Future<Profile> fetchProfile() => repository.fetchMyProfile();

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
    if (profile?.id != null && _hasNext) {
      if (tabIndex == 0) {
        repository
            .fetchTastingRecordPage(
          userId: profile!.id,
          pageNo: _pageNo + 1,
          //수정 필요 정렬 이상함(api)
          orderBy: null,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          //국가 여러개?(api)
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
        )
            .then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _tastingRecords.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (tabIndex == 1) {
        repository.fetchPostPage(userId: profile!.id).then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _posts.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (tabIndex == 2) {
        repository
            .fetchCoffeeBeanPage(
          userId: profile!.id,
          pageNo: _pageNo + 1,
          //수정 필요 정렬 이상함(api)
          orderBy: null,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          //국가 여러개?(api)
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
        )
            .then((page) {
          _pageNo += 1;
          _hasNext = page.hasNext;
          _coffeeBeans.addAll(page.result);
        }).whenComplete(() {
          notifyListeners();
        });
      } else {
        repository.fetchNotePage(userId: profile!.id, pageNo: _pageNo + 1).then((page) {
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
      _currentSortCriteriaIndex = 0;
      _filters.clear();
      paginate(isPageChanged: true);
    }
    notifyListeners();
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    notifyListeners();
  }

  onChangeFilter(List<CoffeeBeanFilter> newFilters) {
    _filters.clear();
    _filters.addAll(newFilters);
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
