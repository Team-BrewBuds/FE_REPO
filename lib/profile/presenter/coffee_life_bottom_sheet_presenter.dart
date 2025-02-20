import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:flutter/foundation.dart';

final class CoffeeLifeBottomSheetPresenter extends ChangeNotifier {
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