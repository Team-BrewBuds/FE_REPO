import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/filter/model/search_sort_criteria.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/domain/search/core/search_presenter.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';

typedef FilterBarState = ({
  int currentTabIndex,
  List<SortCriteria> currentSortCriteriaList,
  int currentSortCriteriaIndex,
  String currentSortCriteria,
  List<CoffeeBeanFilter> filters,
});

typedef PostFilterState = ({
  int currentPostSubjectIndex,
  String currentPostSubject,
});

final class SearchResultPresenter extends SearchPresenter {
  String _previousSearchWord;
  int _previousTabIndex;
  int _currentSortCriteriaIndex = 0;
  int _currentPostSubjectIndex = 0;
  DefaultPage<SearchResultModel> _page = DefaultPage.initState();
  int _pageNo = 1;
  List<CoffeeBeanFilter> _filters = [];

  String get previousSearchWord => _previousSearchWord;

  int get previousTabIndex => _previousTabIndex;

  @override
  bool get hasWord => isSuggestMode && searchWord.isNotEmpty;

  List<SearchResultModel> get resultList => _page.results;

  bool get hasFilter => _filters.isNotEmpty;

  FilterBarState get filterBarState => (
        currentTabIndex: currentTabIndex,
        currentSortCriteriaList: sortCriteriaList,
        currentSortCriteria: sortCriteriaList[_currentSortCriteriaIndex].toString(),
        currentSortCriteriaIndex: currentSortCriteriaIndex,
        filters: _filters,
      );

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<SortCriteria> get sortCriteriaList => switch (currentTabIndex) {
        0 => SortCriteria.coffeeBean(),
        1 => SortCriteria.buddy(),
        2 => SortCriteria.tastedRecord(),
        3 => SortCriteria.post(),
        int() => throw UnimplementedError(),
      };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  int get currentPostSubjectIndex => _currentPostSubjectIndex;

  String get currentPostSubject => PostSubject.values[_currentPostSubjectIndex].toString();

  PostFilterState get postFilterState => (
        currentPostSubjectIndex: currentPostSubjectIndex,
        currentPostSubject: currentPostSubject,
      );

  SearchResultPresenter({
    required super.currentTabIndex,
    required super.searchWord,
  })  : _previousSearchWord = searchWord,
        _previousTabIndex = currentTabIndex;

  @override
  initState() {
    super.initState();
    fetchData();
  }

  fetchMoreData() async {
    if(!_page.hasNext) return;
    switch (currentSubject) {
      case SearchSubject.coffeeBean:
        final newPage = await searchRepository.searchBean(
          searchWord: searchWord,
          pageNo: _pageNo,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
          maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        _page = newPage.copyWith(results: _page.results + newPage.results);
        break;
      case SearchSubject.buddy:
        final newPage = await searchRepository.searchUser(
          searchWord: searchWord,
          pageNo: _pageNo,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        _page = newPage.copyWith(results: _page.results + newPage.results);
        break;
      case SearchSubject.tastedRecord:
        final newPage = await searchRepository.searchTastingRecord(
          searchWord: searchWord,
          pageNo: _pageNo,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
          maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        _page = newPage.copyWith(results: _page.results + newPage.results);
        break;
      case SearchSubject.post:
        final newPage = await searchRepository.searchPost(
          searchWord: searchWord,
          pageNo: _pageNo,
          subject: PostSubject.values[_currentPostSubjectIndex],
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        _page = newPage.copyWith(results: _page.results + newPage.results);
        break;
    }
    _pageNo++;
    notifyListeners();
  }

  @override
  fetchData() async {
    _pageNo = 1;
    switch (currentSubject) {
      case SearchSubject.coffeeBean:
        _page = await searchRepository.searchBean(
          searchWord: searchWord,
          pageNo: _pageNo,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
          maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        break;
      case SearchSubject.buddy:
        _page = await searchRepository.searchUser(
          searchWord: searchWord,
          pageNo: _pageNo,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        break;
      case SearchSubject.tastedRecord:
        _page = await searchRepository.searchTastingRecord(
          searchWord: searchWord,
          pageNo: _pageNo,
          beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
          country: _filters.whereType<CountryFilter>().firstOrNull?.country.toString(),
          isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
          minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
          maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        break;
      case SearchSubject.post:
        _page = await searchRepository.searchPost(
          searchWord: searchWord,
          pageNo: _pageNo,
          subject: PostSubject.values[_currentPostSubjectIndex],
          sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
        );
        break;
    }
    _pageNo++;
    notifyListeners();
  }

  @override
  onComplete(String searchWord) {
    _previousSearchWord = searchWord;
    _previousTabIndex = currentTabIndex;
    fetchData();
    super.onComplete(searchWord);
  }

  @override
  onChangeTab(int index) {
    _filters = List.from([]);
    _currentSortCriteriaIndex = 0;
    _currentPostSubjectIndex = 0;
    super.onChangeTab(index);
  }

  onChangeCoffeeBeanFilter(List<CoffeeBeanFilter> newFilters) {
    _filters = List.from(newFilters);
    fetchData();
    notifyListeners();
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    fetchData();
    notifyListeners();
  }

  onChangePostSubjectFilter(int index) {
    _currentPostSubjectIndex = index;
    fetchData();
    notifyListeners();
  }

  @override
  onRefresh() {
    fetchData();
  }
}
