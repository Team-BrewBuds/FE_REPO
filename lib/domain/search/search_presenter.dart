import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/search_history_repository.dart';
import 'package:brew_buds/data/repository/search_repository.dart';
import 'package:brew_buds/domain/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/domain/search/models/search_result_model.dart';
import 'package:brew_buds/domain/search/models/search_sort_criteria.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_simple.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

enum SearchState {
  main,
  suggesting,
  result;
}

typedef FilterBarState = ({
  int currentTabIndex,
  List<SearchSortCriteria> currentSortCriteriaList,
  int currentSortCriteriaIndex,
  String currentSortCriteria,
  List<CoffeeBeanFilter> filters,
});

typedef PostFilterState = ({
  int currentPostSubjectIndex,
  String currentPostSubject,
});

final class SearchPresenter extends Presenter {
  final SearchHistoryRepository _searchHistoryRepository = SearchHistoryRepository.instance;
  final SearchRepository _searchRepository = SearchRepository.instance;
  late final Debouncer _debouncer;

  //Common State
  SearchState _viewState = SearchState.main;
  SearchState _previousViewState = SearchState.main;
  String _searchWord = '';
  String _previousSearchWord = '';
  int _tabIndex = 0;
  int _previousTabIndex = 0;

  bool get canBack => viewState != SearchState.main;

  SearchState get viewState => _viewState;

  SearchState get previousViewState => _previousViewState;

  String get previousSearchWord => _previousSearchWord;

  int get previousTabIndex => _previousTabIndex;

  //Main State
  List<String> _searchHistory = [];
  List<RecommendedCoffeeBean> _recommendedBeanList = [];
  List<CoffeeBeanSimple> _coffeeBeanRanking = [];
  bool _isLoadingSearchHistory = false;
  bool _isLoadingRecommendedBeanList = false;
  bool _isLoadingRanking = false;

  List<String> get searchHistory => List.unmodifiable(_searchHistory);

  List<RecommendedCoffeeBean> get recommendedBeanList => List.unmodifiable(_recommendedBeanList);

  List<CoffeeBeanSimple> get coffeeBeanRanking => List.unmodifiable(_coffeeBeanRanking);

  bool get isLoadingSearchHistory => _isLoadingSearchHistory;

  bool get isLoadingRecommendedBeanList => _isLoadingRecommendedBeanList;

  bool get isLoadingRanking => _isLoadingRanking;

  //Suggest State
  List<String> _suggestWordList = [];
  bool _isLoadingSuggest = false;

  List<String> get suggestWordList => List.unmodifiable(_suggestWordList);

  bool get isLoadingSuggest => _isLoadingSuggest;

  //Search Result State
  List<SearchResultModel> _searchResultModel = [];
  int _pageNo = 1;
  bool _hasNext = true;
  bool _isLoadingSearch = false;

  List<SearchResultModel> get searchResultModel => List.unmodifiable(_searchResultModel);

  bool get isLoadingSearch => _isLoadingSearch;

  bool get hasNext => _hasNext;

  //Filter State
  int _currentSortCriteriaIndex = 0;
  int _currentPostSubjectIndex = 0;
  List<CoffeeBeanFilter> _filters = [];

  bool get hasFilter => _filters.isNotEmpty;

  FilterBarState get filterBarState => (
        currentTabIndex: _tabIndex,
        currentSortCriteriaList: sortCriteriaList,
        currentSortCriteria: sortCriteriaList[_currentSortCriteriaIndex].toString(),
        currentSortCriteriaIndex: currentSortCriteriaIndex,
        filters: _filters,
      );

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<SearchSortCriteria> get sortCriteriaList => switch (_tabIndex) {
        0 => SearchSortCriteria.coffeeBean(),
        1 => SearchSortCriteria.buddy(),
        2 => SearchSortCriteria.tastedRecord(),
        3 => SearchSortCriteria.post(),
        int() => throw UnimplementedError(),
      };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  int get currentPostSubjectIndex => _currentPostSubjectIndex;

  String get currentPostSubject => PostSubject.values[_currentPostSubjectIndex].toString();

  PostFilterState get postFilterState => (
        currentPostSubjectIndex: currentPostSubjectIndex,
        currentPostSubject: currentPostSubject,
      );

  SearchPresenter() {
    _debouncer = Debouncer(
      const Duration(milliseconds: 300),
      initialValue: null,
      checkEquality: false,
      onChanged: (_) {
        _fetchSuggestWordList();
      },
    );
    initState();
  }

  initState() async {
    await Future.wait([
      fetchHistory(),
      fetchRecommendedBeanList(),
      fetchCoffeeBeanRanking(),
    ]);
  }

  Future<void> onRefreshMain() async {
    _searchHistory = List.empty(growable: true);
    _recommendedBeanList = List.empty(growable: true);
    _coffeeBeanRanking = List.empty(growable: true);
    await Future.wait([
      fetchHistory(isRefresh: true),
      fetchRecommendedBeanList(isRefresh: true),
      fetchCoffeeBeanRanking(isRefresh: true),
    ]);
  }

  Future<void> onRefreshResult() async {
    await fetchMoreData(isTabChange: true, isRefresh: true);
  }

  onChangeViewStateWithMain() {
    _viewState = SearchState.main;
    _searchWord = '';
    _previousSearchWord = '';
    _previousViewState = SearchState.main;
    _tabIndex = 0;
    _previousTabIndex = 0;
    _suggestWordList = List.empty(growable: true);
    _searchResultModel = List.empty(growable: true);
    _pageNo = 1;
    _hasNext = true;
    notifyListeners();
  }

  onChangeViewStateWithSuggesting() {
    if (_viewState != SearchState.suggesting) {
      _previousViewState = _viewState;
      _previousSearchWord = _searchWord;
      _previousTabIndex = _tabIndex;
      _viewState = SearchState.suggesting;
      _suggestWordList = List.empty(growable: true);
      notifyListeners();
      if (_searchWord.isNotEmpty) {
        _fetchSuggestWordList();
      }
    }
  }

  onChangeViewStateWithResult() {
    _searchWord = _previousSearchWord;
    _tabIndex = _previousTabIndex;
    _viewState = SearchState.result;
    _suggestWordList = List.empty(growable: true);
    notifyListeners();
  }

  onTapGoBackState() {
    switch (_viewState) {
      case SearchState.main:
        return;
      case SearchState.suggesting:
        if (_previousViewState == SearchState.result) {
          onChangeViewStateWithResult();
        } else {
          onChangeViewStateWithMain();
        }
        break;
      case SearchState.result:
        onChangeViewStateWithMain();
        break;
    }
  }

  onChangeTab(int index) {
    _tabIndex = index;
    if (_viewState == SearchState.suggesting && _searchWord.length >= 2) {
      _debouncer.setValue(null);
    } else if (_viewState == SearchState.result) {
      fetchMoreData(isTabChange: true);
    }
  }

  Future<void> fetchHistory({isRefresh = false}) async {
    if (_isLoadingSearchHistory) return;
    _isLoadingSearchHistory = true;
    if (!isRefresh) {
      notifyListeners();
    }

    _searchHistory = List.from(await _searchHistoryRepository.getHistory());
    _isLoadingSearchHistory = false;
    notifyListeners();
  }

  removeSearchHistoryAt(int index) async {
    _searchHistory.removeAt(index);
    await _searchHistoryRepository.setSearchHistory(_searchHistory);
    notifyListeners();
  }

  removeAllSearchHistory() async {
    _searchHistory = List.empty(growable: true);
    await _searchHistoryRepository.clearHistory();
    notifyListeners();
  }

  Future<void> fetchRecommendedBeanList({isRefresh = false}) async {
    if (_isLoadingRecommendedBeanList) return;
    _isLoadingRecommendedBeanList = true;
    if (!isRefresh) {
      notifyListeners();
    }

    _recommendedBeanList = await _searchRepository.fetchRecommendedCoffeeBean();
    _isLoadingRecommendedBeanList = false;
    notifyListeners();
  }

  Future<void> fetchCoffeeBeanRanking({isRefresh = false}) async {
    if (_isLoadingRanking) return;
    _isLoadingRanking = true;
    if (!isRefresh) {
      notifyListeners();
    }

    _coffeeBeanRanking = await _searchRepository.fetchCoffeeBeanRanking();
    _isLoadingRanking = false;
    notifyListeners();
  }

  onChangeSearchWord(String newWord) {
    if (newWord.length < 2) return;
    _searchWord = newWord;
    _debouncer.setValue(null);
  }

  _fetchSuggestWordList() async {
    if (_viewState != SearchState.suggesting) return;

    _isLoadingSuggest = true;
    notifyListeners();

    try {
      _suggestWordList = List<String>.from(
        await _searchRepository
            .fetchSuggestSearchWord(
              searchWord: _searchWord,
              subject: SearchSubject.values.elementAt(_tabIndex),
            )
            .onError((_, __) => []),
      );
    } finally {
      _isLoadingSuggest = false;
      notifyListeners();
    }
  }

  search(String word) async {
    if (word != _searchWord) {
      _searchWord = word;
    }

    if (_viewState != SearchState.result) {
      _viewState = SearchState.result;
    }
    try {
      await fetchMoreData(isTabChange: true);
      await _searchHistoryRepository.addSearch(_searchWord);
    } catch (e) {
      return;
    } finally {
      if (_searchHistory.contains(_searchWord)) {
        _searchHistory.remove(_searchWord);
      }
      _searchHistory.insert(0, _searchWord);
      notifyListeners();
    }
  }

  Future<void> fetchMoreData({bool isTabChange = false, bool isRefresh = false, bool isFilterChange = false}) async {
    if (isTabChange) {
      _searchResultModel = List.empty(growable: true);
      _pageNo = 1;
      _hasNext = true;
      _isLoadingSearch = false;
      if (!isRefresh) {
        _resetFilters();
      }
    } else if (isFilterChange) {
      _searchResultModel = List.empty(growable: true);
      _pageNo = 1;
      _hasNext = true;
      _isLoadingSearch = false;
    }

    if (!_hasNext || _isLoadingSearch) return;

    _isLoadingSearch = true;
    if (!isRefresh && _searchResultModel.isEmpty) {
      notifyListeners();
    }

    try {
      final currentTab = SearchSubject.values.elementAtOrNull(_tabIndex);
      final DefaultPage<SearchResultModel> nextPage;
      switch (currentTab) {
        case null:
          return;
        case SearchSubject.coffeeBean:
          nextPage = await _searchRepository.searchBean(
            searchWord: _searchWord,
            pageNo: _pageNo,
            sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
            beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
            isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
            country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
            minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
            maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
            // roastingPointMin: _filters.whereType<RoastingPointFilter>().firstOrNull?.start,
            // roastingPointMax: _filters.whereType<RoastingPointFilter>().firstOrNull?.end,
          );
          break;
        case SearchSubject.buddy:
          nextPage = await _searchRepository.searchUser(
            searchWord: _searchWord,
            pageNo: _pageNo,
            sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
          );
          break;
        case SearchSubject.tastedRecord:
          nextPage = await _searchRepository.searchTastingRecord(
            searchWord: _searchWord,
            pageNo: _pageNo,
            sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
            beanType: _filters.whereType<BeanTypeFilter>().firstOrNull?.type,
            isDecaf: _filters.whereType<DecafFilter>().firstOrNull?.isDecaf,
            country: _filters.whereType<CountryFilter>().map((e) => e.country.toString()).join(','),
            minRating: _filters.whereType<RatingFilter>().firstOrNull?.start,
            maxRating: _filters.whereType<RatingFilter>().firstOrNull?.end,
          );
          break;
        case SearchSubject.post:
          nextPage = await _searchRepository.searchPost(
            searchWord: _searchWord,
            pageNo: _pageNo,
            sortBy: sortCriteriaList[_currentSortCriteriaIndex].toJson(),
            subject: PostSubject.values[_currentPostSubjectIndex],
          );
          break;
      }

      if (currentTab != SearchSubject.values.elementAtOrNull(_tabIndex)) return;

      _searchResultModel.addAll(nextPage.results);
      _hasNext = nextPage.hasNext;
      _pageNo++;
    } catch (e) {
      _searchResultModel = List.empty(growable: true);
      _hasNext = false;
      return;
    } finally {
      _isLoadingSearch = false;
      notifyListeners();
    }
  }

  _resetFilters() {
    _filters = List.empty(growable: true);
    _currentSortCriteriaIndex = 0;
    _currentPostSubjectIndex = 0;
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    notifyListeners();
    fetchMoreData(isFilterChange: true);
  }

  onChangeCoffeeBeanFilter(List<CoffeeBeanFilter> filters) {
    _filters = List.from(filters);
    notifyListeners();
    fetchMoreData(isFilterChange: true);
  }

  onChangePostSubjectFilter(int index) {
    _currentPostSubjectIndex = index;
    notifyListeners();
    fetchMoreData(isFilterChange: true);
  }
}
