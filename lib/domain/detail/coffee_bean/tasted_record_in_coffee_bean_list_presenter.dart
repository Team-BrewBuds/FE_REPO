import 'dart:math';

import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/coffee_bean_repository.dart';
import 'package:brew_buds/domain/detail/coffee_bean/widget/tasted_record_in_coffee_bean_presenter.dart';

final class TastedRecordInCoffeeBeanListPresenter extends Presenter {
  final int id;
  final CoffeeBeanRepository _coffeeBeanRepository = CoffeeBeanRepository.instance;
  final List<TastedRecordInCoffeeBeanPresenter> _presenters = List.empty(growable: true);

  List<TastedRecordInCoffeeBeanPresenter> get previewPresenters =>
      List.unmodifiable(_presenters.sublist(0, min(_presenters.length, 4)));

  List<TastedRecordInCoffeeBeanPresenter> get presenters => List.unmodifiable(_presenters);

  int get count => _presenters.length;

  TastedRecordInCoffeeBeanListPresenter({
    required this.id,
  }) {
    fetchData();
  }

  fetchData() async {
    final newPage = await _coffeeBeanRepository.fetchTastedRecordsForCoffeeBean(id: id);
    _presenters.addAll(newPage.results.map((e) => TastedRecordInCoffeeBeanPresenter(tastedRecordInCoffeeBean: e)));
    notifyListeners();
  }
}
