import 'dart:convert';

import 'package:brew_buds/data/api/beans_api.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:flutter/foundation.dart';

typedef CoffeeBeanSearchResult = ({String searchWord, List<CoffeeBean> coffeebeans});

final class CoffeeBeanSearchPresenter extends ChangeNotifier {
  final BeansApi _beansApi = BeansApi();
  DefaultPage<CoffeeBean> _page = DefaultPage.empty();
  String _searchWord = '';
  int _currentPage = 1;

  CoffeeBeanSearchResult get result => (searchWord: _searchWord, coffeebeans: _page.result);

  List<CoffeeBean> get coffeeBeans => _page.result;

  search(String word) async {
    _page = DefaultPage.empty();
    _currentPage = 1;
    _searchWord = word;
    final jsonString = await _beansApi.searchBeans(name: word, pageNo: _currentPage).onError((error, stackTrace) => '');
    if (jsonString.isEmpty) return;

    final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
    final hasNext = (jsonData['next'] as String?)?.isNotEmpty ?? false;
    final results = jsonData['results'] as List<dynamic>? ?? [];
    final coffeeBeanList = results.map((e) => CoffeeBean.fromJson(e as Map<String, dynamic>)).toList();
    _page = _page.copyWith(result: coffeeBeanList, hasNext: hasNext);
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
      _page = _page.copyWith(result: _page.result + coffeeBeanList, hasNext: hasNext);
      _currentPage++;
      notifyListeners();
    }
  }

  onChangeSearchWord(String newSearchWord) {
    _searchWord = newSearchWord;
  }
}
