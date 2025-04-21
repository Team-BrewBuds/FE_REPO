import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/profile/model/profile_sort_criteria.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/noted/noted_object.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/profile/profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:flutter/foundation.dart';

typedef ProfileState = ({String imageUrl, int tastingRecordCount, int followerCount, int followingCount});
typedef ProfileDetailState = ({List<String> coffeeLife, String introduction, String profileLink});
typedef FilterBarState = ({
  bool canShowFilterBar,
  List<String> sortCriteriaList,
  int currentIndex,
  List<CoffeeBeanFilter> filters,
});

class ProfilePresenter extends Presenter {
  final ProfileRepository repository = ProfileRepository.instance;
  Profile? profile;
  DefaultPage<TastedRecordInProfile> _tastingRecordsPage = DefaultPage.initState();
  DefaultPage<PostInProfile> _postsPage = DefaultPage.initState();
  DefaultPage<BeanInProfile> _beansPage = DefaultPage.initState();
  DefaultPage<NotedObject> _savedNotesPage = DefaultPage.initState();
  bool _isLoading = false;
  bool _isLoadingData = false;
  int _currentSortCriteriaIndex = 0;
  final List<CoffeeBeanFilter> _filters = [];
  int _tabIndex = 0;
  int _pageNo = 1;
  bool _isEmpty = false;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<ProfileSortCriteria> get sortCriteriaList => switch (_tabIndex) {
        0 => ProfileSortCriteria.tastedRecord(),
        1 => [],
        2 => ProfileSortCriteria.notedCoffeeBean(),
        3 => [],
        int() => throw UnimplementedError(),
      };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  bool get isLoading => _isLoading;

  bool get isLoadingData => _isLoadingData;

  bool get isEmpty => _isEmpty;

  int get id => profile?.id ?? 0;

  String get nickName => profile?.nickname ?? '';

  ProfileState get profileState => (
        imageUrl: profile?.profileImageUrl ?? '',
        tastingRecordCount: profile?.tastedRecordCnt ?? 0,
        followerCount: profile?.followerCount ?? 0,
        followingCount: profile?.followingCount ?? 0,
      );

  ProfileDetailState get profileDetailState => (
        coffeeLife: profile?.coffeeLife.map((coffeeLife) => coffeeLife.title).toList() ?? [],
        introduction: profile?.introduction ?? '',
        profileLink: profile?.profileLink ?? '',
      );

  FilterBarState get filterBarState => (
        canShowFilterBar: (_tabIndex == 0 && _tastingRecordsPage.results.isNotEmpty) ||
            (_tabIndex == 2 && _beansPage.results.isNotEmpty),
        sortCriteriaList: sortCriteriaList.map((sortCriteria) => sortCriteria.toString()).toList(),
        currentIndex: _currentSortCriteriaIndex,
        filters: _filters,
      );

  DefaultPage? get currentPage {
    if (_tabIndex == 0) {
      return _tastingRecordsPage;
    } else if (_tabIndex == 1) {
      return _postsPage;
    } else if (_tabIndex == 2) {
      return _beansPage;
    } else {
      return _savedNotesPage;
    }
  }

  bool get hasNext => currentPage?.hasNext ?? false;

  initState() async {
    _isLoading = true;
    notifyListeners();

    profile = await fetchProfile().then((value) => Future<Profile?>.value(value)).onError((error, stackTrace) => null);
    if (profile?.id != null) {
      paginate(isPageChanged: true);
    } else {
      _isEmpty = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  refresh() async {
    _isLoading = true;
    notifyListeners();

    profile = await fetchProfile();
    if (profile?.id != null) {
      paginate(isPageChanged: true);
    } else {
      _isEmpty = true;
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<Profile> fetchProfile() => repository.fetchMyProfile();

  paginate({bool isPageChanged = false}) {
    if (isPageChanged) {
      _pageNo = 1;
      _tastingRecordsPage = DefaultPage.initState();
      _postsPage = DefaultPage.initState();
      _beansPage = DefaultPage.initState();
      _savedNotesPage = DefaultPage.initState();
      notifyListeners();
    }

    if (hasNext) {
      _fetchPage();
    }
  }

  _fetchPage() async {
    final id = profile?.id;
    if (id != null) {
      if (currentPage?.results.isEmpty ?? true) {
        _isLoadingData = true;
        notifyListeners();
      }

      if (_tabIndex == 0) {
        final nextPage = await repository.fetchTastedRecordPage(
          userId: id,
          pageNo: _pageNo,
          orderBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toJson(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
          roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
        );

        _tastingRecordsPage = await compute(
          (message) {
            return message.$2.copyWith(results: message.$1.results + message.$2.results);
          },
          (_tastingRecordsPage, nextPage),
        );
        _pageNo++;
        _isLoadingData = false;
        notifyListeners();
      } else if (_tabIndex == 1) {
        final nextPage = await repository.fetchPostPage(userId: id);
        _postsPage = await compute(
          (message) {
            return message.$2.copyWith(results: message.$1.results + message.$2.results);
          },
          (_postsPage, nextPage),
        );
        _isLoadingData = false;
        notifyListeners();
      } else if (_tabIndex == 2) {
        final nextPage = await repository.fetchCoffeeBeanPage(
          userId: id,
          pageNo: _pageNo,
          orderBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
          roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
          roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
          ratingMin: _filters.whereType<RatingFilter>().firstOrNull?.start,
          ratingMax: _filters.whereType<RatingFilter>().firstOrNull?.end,
        );
        _beansPage = await compute(
          (message) {
            return message.$2.copyWith(results: message.$1.results + message.$2.results);
          },
          (_beansPage, nextPage),
        );
        _pageNo++;
        _isLoadingData = false;
        notifyListeners();
      } else {
        final nextPage = await repository.fetchNotePage(userId: id, pageNo: _pageNo);

        _savedNotesPage = await compute(
          (message) {
            return message.$2.copyWith(results: message.$1.results + message.$2.results);
          },
          (_savedNotesPage, nextPage),
        );
        _pageNo++;
        _isLoadingData = false;
        notifyListeners();
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
    paginate(isPageChanged: true);
    notifyListeners();
  }

  onChangeFilter(List<CoffeeBeanFilter> newFilters) {
    _filters.clear();
    _filters.addAll(newFilters);
    paginate(isPageChanged: true);
    notifyListeners();
  }
}
