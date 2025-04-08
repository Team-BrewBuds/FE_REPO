import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';

final class AccountDetailPresenter extends Presenter {
  final ProfileRepository _repository = ProfileRepository.instance;
  List<CoffeeLife>? _preCoffeeLife;
  bool? _preIsCertificated;
  int? _preBodyValue;
  int? _preAcidityValue;
  int? _preBitternessValue;
  int? _preSweetnessValue;

  List<CoffeeLife> _selectedCoffeeLifeList = [];
  bool? _isCertificated;
  int? _bodyValue;
  int? _acidityValue;
  int? _bitternessValue;
  int? _sweetnessValue;

  bool _isLoading = true;

  bool get isLoading => _isLoading;

  bool get canEdit {
    if (_preIsCertificated == null ||
        _preBodyValue == null ||
        _preAcidityValue == null ||
        _preBitternessValue == null ||
        _preSweetnessValue == null ||
        _preCoffeeLife == null) {
      return false;
    }

    return (_preIsCertificated != _isCertificated ||
      _preBodyValue != _bodyValue ||
      _preAcidityValue != _acidityValue ||
      _preBitternessValue != _bitternessValue ||
      _preSweetnessValue != _sweetnessValue ||
      _compareCoffeeLifeList());
  }

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  bool? get isCertificated => _isCertificated;

  int? get bodyValue => _bodyValue;

  int? get acidityValue => _acidityValue;

  int? get bitternessValue => _bitternessValue;

  int? get sweetnessValue => _sweetnessValue;

  bool _compareCoffeeLifeList() {
    if (_preCoffeeLife?.isEmpty ?? true && selectedCoffeeLifeList.isEmpty) {
      return false;
    } else if (_preCoffeeLife?.isEmpty ?? true && selectedCoffeeLifeList.isNotEmpty) {
      return true;
    } else if (_preCoffeeLife?.length == selectedCoffeeLifeList.length) {
      return _preCoffeeLife?.map((e) => selectedCoffeeLifeList.contains(e)).where((element) => !element).isNotEmpty ?? false;
    } else {
      return true;
    }
  }

  bool _compareBeanTaste() {
    return (_preBodyValue != _bodyValue ||
        _preAcidityValue != _acidityValue ||
        _preBitternessValue != _bitternessValue ||
        _preSweetnessValue != _sweetnessValue);
  }

  initState() {
    fetchProfileDetail();
  }

  fetchProfileDetail() async {
    _isLoading = true;
    notifyListeners();

    _repository.fetchMyProfile().then((newProfile) {
      _selectedCoffeeLifeList = List.from(newProfile.coffeeLife);
      _isCertificated = newProfile.isCertificated;
      _bodyValue = newProfile.preferredBeanTaste.body;
      _acidityValue = newProfile.preferredBeanTaste.acidity;
      _bitternessValue = newProfile.preferredBeanTaste.bitterness;
      _sweetnessValue = newProfile.preferredBeanTaste.sweetness;

      _preCoffeeLife = List.from(newProfile.coffeeLife);
      _preBodyValue = newProfile.preferredBeanTaste.body;
      _preAcidityValue = newProfile.preferredBeanTaste.acidity;
      _preBitternessValue = newProfile.preferredBeanTaste.bitterness;
      _preSweetnessValue = newProfile.preferredBeanTaste.sweetness;
      _preIsCertificated = newProfile.isCertificated;
    }).whenComplete(() {
      _isLoading = false;
      notifyListeners();
    });
  }

  onSelectCoffeeLife(CoffeeLife coffeeLife) {
    if (selectedCoffeeLifeList.contains(coffeeLife)) {
      _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList)..remove(coffeeLife);
    } else {
      _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList)..add(coffeeLife);
    }
    notifyListeners();
  }

  onSelectCertificated(bool isCertificated) {
    if (_isCertificated == isCertificated) {
      _isCertificated = null;
    } else {
      _isCertificated = isCertificated;
    }
    notifyListeners();
  }

  onSelectBodyValue(int bodyValue) {
    if (_bodyValue == bodyValue) {
      _bodyValue = null;
    } else {
      _bodyValue = bodyValue;
    }
    notifyListeners();
  }

  onSelectAcidityValue(int acidityValue) {
    if (_acidityValue == acidityValue) {
      _acidityValue = null;
    } else {
      _acidityValue = acidityValue;
    }
    notifyListeners();
  }

  onSelectBitternessValue(int bitternessValue) {
    if (_bitternessValue == bitternessValue) {
      _bitternessValue = null;
    } else {
      _bitternessValue = bitternessValue;
    }
    notifyListeners();
  }

  onSelectSweetValue(int sweetValue) {
    if (_sweetnessValue == sweetValue) {
      _sweetnessValue = null;
    } else {
      _sweetnessValue = sweetValue;
    }
    notifyListeners();
  }

  Future<void> onSave() {
    return _repository.updateProfile(
        coffeeLife: _compareCoffeeLifeList() ? selectedCoffeeLifeList : null,
        preferredBeanTaste: _compareBeanTaste()
            ? PreferredBeanTaste(
                body: _bodyValue ?? 0,
                acidity: _acidityValue ?? 0,
                sweetness: _sweetnessValue ?? 0,
                bitterness: _bitternessValue ?? 0,
              )
            : null,
        isCertificated: _preIsCertificated != _isCertificated ? _isCertificated : null);
  }
}
