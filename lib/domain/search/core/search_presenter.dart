import 'package:brew_buds/data/repository/search_repository.dart';
import 'package:brew_buds/data/repository/shared_preferences_repository.dart';
import 'package:brew_buds/domain/search/models/search_subject.dart';
import 'package:flutter/foundation.dart';

typedef SuggestState = ({List<String> suggestSearchWords, String searchWord});

abstract class SearchPresenter extends ChangeNotifier {
  final SharedPreferencesRepository sharedPreferencesRepository = SharedPreferencesRepository.instance;
  final SearchRepository searchRepository = SearchRepository.instance;
  final List<SearchSubject> _searchSubjectList = SearchSubject.values;
  bool _isSuggestMode = false;
  int _currentTabIndex;
  String _searchWord;
  List<String> _suggestSearchWords = [];

  List<String> recentSearchWords = [];

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
    fetchData();
  }

  onRefresh() {
    fetchData();
  }

  onChangeSearchWord(String searchWord) {
    _searchWord = searchWord;
    fetchSuggestWords();
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
    recentSearchWords = List.from(sharedPreferencesRepository.recentSearchWords);
    notifyListeners();
  }

  fetchData() {
    fetchRecentSearchWords();
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
