import 'package:brew_buds/data/repository/search_repository.dart';
import 'package:brew_buds/filter/model/coffee_bean_filter.dart';
import 'package:brew_buds/search/models/search_result_model.dart';
import 'package:brew_buds/filter/model/search_sort_criteria.dart';
import 'package:brew_buds/search/models/search_subject.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:flutter/foundation.dart';

typedef SuggestState = ({List<String> suggestWords, List<String> suggestRecentWords});

final class SearchPresenter extends ChangeNotifier {
  final SearchRepository _searchRepository = SearchRepository.instance;
  late final Debouncer _suggestThrottle = Debouncer<String>(
    const Duration(milliseconds: 300),
    initialValue: '',
    onChanged: (value) {
      _fetchSuggestWords(value);
    },
  );
  final List<SearchSubject> _subjects = [
    SearchSubject.coffeeBean,
    SearchSubject.buddy,
    SearchSubject.tastedRecord,
    SearchSubject.post,
  ];
  int _tabIndex = 0;
  String _searchWord = '';
  int _currentSortCriteriaIndex = 0;

  List<String> _recentSearchWords = [];

  List<String> _suggestSearchWords = [];

  SuggestState get suggestState => (
        suggestWords: _suggestSearchWords,
        suggestRecentWords:
        _searchWord.isEmpty ? [] : _recentSearchWords.where((word) => word.contains(_searchWord)).toList(),
      );

  final List<CoffeeBeanFilter> _filter = [];

  bool get hasFilter => _filter.isNotEmpty;

  bool get hasBeanTypeFilter => _filter.whereType<BeanTypeFilter>().isNotEmpty;

  bool get hasCountryFilter => _filter.whereType<CountryFilter>().isNotEmpty;

  bool get hasRatingFilter => _filter.whereType<RatingFilter>().isNotEmpty;

  bool get hasDecafFilter => _filter.whereType<DecafFilter>().isNotEmpty;

  bool get hasRoastingPointFilter => _filter.whereType<RoastingPointFilter>().isNotEmpty;

  String get searchWord => _searchWord;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<SortCriteria> get sortCriteriaList => switch (_tabIndex) {
        0 => SortCriteria.coffeeBean(),
        1 => SortCriteria.buddy(),
        2 => SortCriteria.tastedRecord(),
        3 => SortCriteria.post(),
        int() => throw UnimplementedError(),
      };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  List<SearchSubject> get tabs => _subjects;

  int get currentTabIndex => _tabIndex;

  SearchSubject get currentTab => _subjects[_tabIndex];

  List<String> get recentSearchWords => [];

  List<String> get haveSearchedWords => [];

  List<String> get suggestWords => [];

  List<(String, double, int)> get recommendedCoffeeBeans => [];

  List<String> get coffeeBeansRanking => [];

  String get rankUpdatedAt => '10.27 16:00 업데이트';

  List<SearchResultModel> get searchResult => [];

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  _fetchSuggestWords(String word) async {
    final result = await _searchRepository.fetchSuggestSearchWord(
      searchWord: word,
      subject: SearchSubject.values[_tabIndex],
    );
    _suggestSearchWords = List.from(result);
    notifyListeners();
  }

  onChangeTab(int index) {
    _tabIndex = index;
    _filter.clear();
    _currentSortCriteriaIndex = 0;
    notifyListeners();
  }

  onChangeSearchWord(String newText) async {
    _searchWord = newText;
    _suggestThrottle.setValue(newText);
    notifyListeners();
  }

  onDeleteRecentSearchWord(int index) {
    notifyListeners();
  }

  onAllDeleteRecentSearchWord() {
    notifyListeners();
  }

  onChangeCoffeeBeanFilter(List<CoffeeBeanFilter> filter) {
    _filter.clear();
    _filter.addAll(filter);
    notifyListeners();
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    notifyListeners();
  }
}
