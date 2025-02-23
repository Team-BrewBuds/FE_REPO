import 'dart:math';

import 'package:brew_buds/data/repository/search_repository.dart';
import 'package:brew_buds/search/models/search_subject.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

typedef SuggestState = ({List<String> suggestSearchWords, String searchWord});

abstract class SearchPresenter extends ChangeNotifier {
  final storage = const FlutterSecureStorage();
  final SearchRepository searchRepository = SearchRepository.instance;
  final List<SearchSubject> _searchSubjectList = SearchSubject.values;
  bool _isSuggestMode = false;
  int _currentTabIndex;
  String _searchWord;
  List<String> _suggestSearchWords = [];

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

  fetchData();

  onComplete();

  SearchPresenter({
    required int currentTabIndex,
    required String searchWord,
  })  : _currentTabIndex = currentTabIndex,
        _searchWord = searchWord;
}
