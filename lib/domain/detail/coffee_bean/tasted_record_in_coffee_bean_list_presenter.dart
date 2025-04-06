import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';

final class TastedRecordInCoffeeBeanListPresenter extends Presenter {
  final int id;
  final CoffeeBeanRepository _coffeeBeanRepository = CoffeeBeanRepository.instance;
  DefaultPage<TastedRecordInCoffeeBean> _page = DefaultPage.initState();

  DefaultPage<TastedRecordInCoffeeBean> get page => _page;

  int get count => _page.count;

  TastedRecordInCoffeeBeanListPresenter({
    required this.id,
  });

  initState() {
    fetchMoreData();
  }

  fetchMoreData() async {
    if (_page.hasNext) {
      final newPage = await _coffeeBeanRepository.fetchTastedRecordsForCoffeeBean(id: id);
      _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext);
      notifyListeners();
    }
  }
}