import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:flutter/foundation.dart';

typedef CoffeeBeanSearchResult = ({String searchWord, List<CoffeeBean> coffeebeans});

final class CoffeeBeanSearchPresenter extends ChangeNotifier {
  final CoffeeBeanRepository _coffeeBeanRepository = CoffeeBeanRepository.instance;
  DefaultPage<CoffeeBean> _page = DefaultPage.initState();
  String _searchWord = '';
  int _currentPage = 1;

  CoffeeBeanSearchResult get result => (searchWord: _searchWord, coffeebeans: _page.results);

  List<CoffeeBean> get coffeeBeans => _page.results;

  search(String word) async {
    _page = DefaultPage.initState();
    _currentPage = 1;
    _searchWord = word;
    _page = await _coffeeBeanRepository.fetchCoffeeBeans(word: _searchWord, pageNo: _currentPage);
    _currentPage++;
    notifyListeners();
  }

  fetchMoreData() async {
    if (_page.hasNext) {
      final newPage = await _coffeeBeanRepository.fetchCoffeeBeans(word: _searchWord, pageNo: _currentPage);
      _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext, count: newPage.count);
      _currentPage++;
      notifyListeners();
    }
  }

  onChangeSearchWord(String newSearchWord) {
    _searchWord = newSearchWord;
  }
}
