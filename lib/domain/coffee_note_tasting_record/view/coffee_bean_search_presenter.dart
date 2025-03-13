import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:flutter/foundation.dart';

typedef CoffeeBeanSearchResult = ({String searchWord, List<CoffeeBean> coffeebeans});

final class CoffeeBeanSearchPresenter extends ChangeNotifier {
  final BeansApi _beansApi = BeansApi();
  DefaultPage<CoffeeBean> _page = DefaultPage.initState();
  String _searchWord = '';
  int _currentPage = 1;

  CoffeeBeanSearchResult get result => (searchWord: _searchWord, coffeebeans: _page.results);

  List<CoffeeBean> get coffeeBeans => _page.results;

  search(String word) async {
    _page = DefaultPage.initState();
    _currentPage = 1;
    _searchWord = word;
    final jsonString = await _beansApi.searchBeans(name: word, pageNo: _currentPage).onError((error, stackTrace) => '');
    if (jsonString.isEmpty) return;

    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final hasNext = (jsonData['next'] as String?)?.isNotEmpty ?? false;
    final results = jsonData['results'] as List<dynamic>? ?? [];
    final coffeeBeanList = results.map((e) => CoffeeBean.fromJson(e as Map<String, dynamic>)).toList();
    _page = _page.copyWith(results: coffeeBeanList, hasNext: hasNext);
    _currentPage++;
    notifyListeners();
  }

  fetchMoreData() async {
    if (_page.hasNext) {
      final jsonString = await _beansApi.searchBeans(name: _searchWord, pageNo: _currentPage).onError((error, stackTrace) => '');
      if (jsonString.isEmpty) return;

      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final hasNext = (jsonData['next'] as String?)?.isNotEmpty ?? false;
      final results = jsonData['results'] as List<dynamic>? ?? [];
      final coffeeBeanList = results.map((e) => CoffeeBean.fromJson(e as Map<String, dynamic>)).toList();
      _page = _page.copyWith(results: _page.results + coffeeBeanList, hasNext: hasNext);
      _currentPage++;
      notifyListeners();
    }
  }

  onChangeSearchWord(String newSearchWord) {
    _searchWord = newSearchWord;
  }
}
