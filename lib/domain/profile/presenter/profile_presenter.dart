import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/model/search_sort_criteria.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:brew_buds/model/profile/profile.dart';
import 'package:brew_buds/model/noted/noted_object.dart';

typedef ProfileState = ({String imageUrl, int tastingRecordCount, int followerCount, int followingCount});
typedef ProfileDetailState = ({List<String> coffeeLife, String introduction, String profileLink});
typedef FilterBarState = ({
  bool canShowFilterBar,
  List<String> sortCriteriaList,
  int currentIndex,
  List<CoffeeBeanFilter> filters,
});

class ProfilePresenter extends Presenter {
  final List<SortCriteria> _sortCriteriaList = [
    SortCriteria.upToDate,
    SortCriteria.rating,
    SortCriteria.tastingRecords,
  ];

  final ProfileRepository repository;
  Profile? profile;
  DefaultPage<TastedRecordInProfile> _tastingRecordsPage = DefaultPage.initState();
  DefaultPage<PostInProfile> _postsPage = DefaultPage.initState();
  DefaultPage<BeanInProfile> _beansPage = DefaultPage.initState();
  DefaultPage<NotedObject> _savedNotesPage = DefaultPage.initState();
  int _currentSortCriteriaIndex = 0;
  final List<CoffeeBeanFilter> _filters = [];
  int _tabIndex = 0;
  int _pageNo = 0;
  bool _isEmpty = false;

  bool get isEmpty => _isEmpty;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  int get id => profile?.id ?? 0;

  String get nickName => profile?.nickname ?? '';

  ProfileState get profileState => (
        imageUrl: profile?.profileImageUrl ?? '',
        tastingRecordCount: profile?.postCount ?? 0,
        followerCount: profile?.followerCount ?? 0,
        followingCount: profile?.followingCount ?? 0,
      );

  ProfileDetailState get profileDetailState => (
        coffeeLife: profile?.coffeeLife.map((coffeeLife) => coffeeLife.title).toList() ?? [],
        introduction: profile?.introduction ?? '',
        profileLink: profile?.profileLink ?? '',
      );

  FilterBarState get filterBarState => (
        canShowFilterBar: _tabIndex == 0 || _tabIndex == 2,
        sortCriteriaList: _sortCriteriaList.map((sortCriteria) => sortCriteria.toString()).toList(),
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

  bool get isScrollable => currentPage?.results.isNotEmpty ?? false;

  ProfilePresenter({required this.repository});

  initState() async {
    profile = await fetchProfile().then((value) => Future<Profile?>.value(value)).onError((error, stackTrace) => null);
    if (profile?.id != null) {
      paginate(isPageChanged: true);
    } else {
      _isEmpty = true;
    }
    notifyListeners();
  }

  refresh() async {
    profile = await fetchProfile();
    if (profile?.id != null) {
      paginate(isPageChanged: true);
    } else {
      _isEmpty = true;
    }
    notifyListeners();
  }

  Future<Profile> fetchProfile() => repository.fetchMyProfile();

  paginate({bool isPageChanged = false}) {
    if (isPageChanged) {
      _pageNo = 0;
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

  _fetchPage() {
    final id = profile?.id;
    if (id != null) {
      if (_tabIndex == 0) {
        repository
            .fetchTastedRecordPage(
          userId: id,
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
          _tastingRecordsPage = page.copyWith(results: _tastingRecordsPage.results + page.results);
          _pageNo += 1;
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (_tabIndex == 1) {
        repository.fetchPostPage(userId: id).then((page) {
          _postsPage = page.copyWith(results: _postsPage.results + page.results);
          _pageNo += 1;
        }).whenComplete(() {
          notifyListeners();
        });
      } else if (_tabIndex == 2) {
        repository
            .fetchCoffeeBeanPage(
          userId: id,
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
          _beansPage = page.copyWith(results: _beansPage.results + page.results);
          _pageNo += 1;
        }).whenComplete(() {
          notifyListeners();
        });
      } else {
        repository.fetchNotePage(userId: id, pageNo: _pageNo + 1).then((page) {
          _savedNotesPage = page.copyWith(results: _savedNotesPage.results + page.results);
          _pageNo += 1;
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
}
