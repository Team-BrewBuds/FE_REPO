import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

typedef CoffeeBeanSearchState = ({bool isLoading, List<CoffeeBean> coffeebeans});

final class CoffeeBeanSearchPresenter extends Presenter {
  late final Debouncer<String> _searchDebouncer;
  final CoffeeBeanRepository _coffeeBeanRepository = CoffeeBeanRepository.instance;
  final List<CoffeeBean> _coffeeBeanList = List.empty(growable: true);
  String _searchWord = '';
  int _currentPage = 1;
  bool _hasNext = true;
  bool _isLoading = false;

  CoffeeBeanSearchState get coffeeBeanSearchState => (
        isLoading: _isLoading && _coffeeBeanList.isNotEmpty,
        coffeebeans: List.unmodifiable(_coffeeBeanList),
      );

  bool get hasNext => _hasNext;

  CoffeeBeanSearchPresenter() {
    _searchDebouncer = Debouncer(
      const Duration(milliseconds: 300),
      initialValue: '',
      checkEquality: true,
      onChanged: (value) => search(value),
    );
  }

  search(String word) async {
    _hasNext = true;
    _currentPage = 1;
    _searchWord = word;
    _coffeeBeanList.clear();
    _isLoading = true;
    notifyListeners();
    final newPage = await _coffeeBeanRepository.fetchCoffeeBeans(word: _searchWord, pageNo: _currentPage);
    _coffeeBeanList.addAll(newPage.results);
    _hasNext = newPage.hasNext;
    _currentPage++;
    _isLoading = false;
    notifyListeners();
  }

  fetchMoreData() async {
    if (_hasNext && !_isLoading) {
      _isLoading = true;
      notifyListeners();

      final newPage = await _coffeeBeanRepository.fetchCoffeeBeans(word: _searchWord, pageNo: _currentPage);
      _coffeeBeanList.addAll(newPage.results);
      _hasNext = newPage.hasNext;
      _currentPage++;
      _isLoading = false;
      notifyListeners();
    }
  }

  onChangeSearchWord(String newSearchWord) {
    _searchWord = newSearchWord;
    _searchDebouncer.setValue(newSearchWord);
  }
}
