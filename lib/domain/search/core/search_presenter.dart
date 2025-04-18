import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/search_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

typedef SuggestState = ({List<String> suggestSearchWords, String searchWord});

abstract class SearchPresenter extends Presenter {
  final SharedPreferencesRepository sharedPreferencesRepository = SharedPreferencesRepository.instance;
  final SearchRepository searchRepository = SearchRepository.instance;
  final List<SearchSubject> _searchSubjectList = SearchSubject.values;
  late final Debouncer suggestThrottle;
  bool _isLoadingRecentSearchWords = false;
  bool _isSuggestMode = false;
  int _currentTabIndex;
  String _searchWord;
  List<String> _suggestSearchWords = [];

  List<String> recentSearchWords = [];

  bool get isLoadingRecentSearchWords => _isLoadingRecentSearchWords;

  String get searchWord => _searchWord;

  int get currentTabIndex => _currentTabIndex;

  bool get isSuggestMode => _isSuggestMode;

  SearchSubject get currentSubject => _searchSubjectList[_currentTabIndex];

  SuggestState get suggestState => (
        suggestSearchWords: _suggestSearchWords,
        searchWord: _searchWord,
      );

  bool get hasWord => _searchWord.isNotEmpty;

  initState() {
    suggestThrottle = Debouncer<String>(
      const Duration(milliseconds: 300),
      initialValue: '',
      checkEquality: false,
      onChanged: (value) {
        fetchSuggestWords();
      },
    );
    fetchRecentSearchWords();
  }

  onRefresh();

  fetchData();

  onChangeSearchWord(String searchWord) {
    suggestThrottle.setValue(searchWord);
    _searchWord = searchWord;
  }

  onChangeTab(int index) {
    if (_currentTabIndex != index) {
      _currentTabIndex = index;
      if (_isSuggestMode) {
        fetchSuggestWords();
      } else {
        fetchData();
      }
    }
  }

  onChangePageState(bool isSuggestMode) {
    _isSuggestMode = isSuggestMode;
  }

  fetchSuggestWords() async {
    if (_searchWord.length < 2) {
      _suggestSearchWords = List.from([]);
    } else {
      final result = await searchRepository.fetchSuggestSearchWord(
        searchWord: _searchWord,
        subject: currentSubject,
      );
      if (result.isNotEmpty && result.length > 5) {
        _suggestSearchWords = List.from(result.sublist(0, 5));
      } else {
        _suggestSearchWords = List.from(result);
      }
    }
    notifyListeners();
  }

  fetchRecentSearchWords() {
    _isLoadingRecentSearchWords = true;
    notifyListeners();

    recentSearchWords = List.from(sharedPreferencesRepository.recentSearchWords);
    _isLoadingRecentSearchWords = false;
    notifyListeners();
  }

  removeAtRecentSearchWord(int index) async {
    recentSearchWords = List.from(recentSearchWords)..removeAt(index);
    await sharedPreferencesRepository.setRecentSearchWords(recentSearchWords);
    notifyListeners();
  }

  removeAllRecentSearchWord() async {
    recentSearchWords = List.empty();
    await sharedPreferencesRepository.removeAllSearchWords();
    notifyListeners();
  }

  onComplete(String searchWord) async {
    if (recentSearchWords.contains(searchWord)) {
      recentSearchWords.remove(searchWord);
    }
    await sharedPreferencesRepository.setRecentSearchWords([searchWord] + recentSearchWords);
  }

  SearchPresenter({
    required int currentTabIndex,
    required String searchWord,
  })  : _currentTabIndex = currentTabIndex,
        _searchWord = searchWord;
}
