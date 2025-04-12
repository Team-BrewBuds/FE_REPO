import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/model/common/coffee_life.dart';

final class CoffeeLifeBottomSheetPresenter extends Presenter {
  final List<CoffeeLife> _selectedCoffeeLifeList;

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  CoffeeLifeBottomSheetPresenter({
    required List<CoffeeLife> selectedCoffeeLifeList,
  }) : _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList);

  onSelectCoffeeLife(CoffeeLife coffeeLife) {
    if (_selectedCoffeeLifeList.contains(coffeeLife)) {
      _selectedCoffeeLifeList.remove(coffeeLife);
    } else {
      _selectedCoffeeLifeList.add(coffeeLife);
    }
    notifyListeners();
  }

  reset() {
    _selectedCoffeeLifeList.clear();
    notifyListeners();
  }
}
