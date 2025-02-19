import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:brew_buds/profile/model/profile.dart';
import 'package:flutter/foundation.dart';

final class AccountDetailPresenter extends ChangeNotifier {
  final ProfileApi _api = ProfileApi();
  Profile? _profile;

  List<CoffeeLife>? get selectedCoffeeLife => _profile?.coffeeLife;

  bool? get isCertificated => _profile?.isCertificated;

  int? get bodyValue => _profile?.preferredBeanTaste.body;

  int? get acidityValue => _profile?.preferredBeanTaste.acidity;

  int? get bitternessValue => _profile?.preferredBeanTaste.bitterness;

  int? get sweetnessValue => _profile?.preferredBeanTaste.sweetness;

  initState() {
    fetchProfileDetail();
  }

  onRefresh() {
    fetchProfileDetail();
  }

  fetchProfileDetail() {
    _api.fetchMyProfile().then((newProfile) {
      _profile = newProfile;
      notifyListeners();
    });
  }

  onSelectCoffeeLife(CoffeeLife coffeeLife) {
    final profile = _profile;

    if (profile != null) {
      if (profile.coffeeLife.contains(coffeeLife)) {
        final List<CoffeeLife> currentCoffeeLifeList = List.from(profile.coffeeLife);
        _profile = profile.copyWith(coffeeLife: currentCoffeeLifeList..remove(coffeeLife));
      } else {
        _profile = profile.copyWith(coffeeLife: profile.coffeeLife + [coffeeLife]);
      }
      notifyListeners();
    }
  }

  onSelectCertificated(bool isCertificated) {
    final profile = _profile;

    if (profile != null) {
      if (profile.isCertificated == isCertificated) {
        _profile = profile.copyWith(isCertificated: null);
      } else {
        _profile = profile.copyWith(isCertificated: isCertificated);
      }
      notifyListeners();
    }
  }

  onSelectBodyValue(int bodyValue) {
    final profile = _profile;

    if (profile != null) {
      if (profile.preferredBeanTaste.body == bodyValue) {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(body: 0));
      } else {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(body: bodyValue));
      }
      notifyListeners();
    }
  }

  onSelectAcidityValue(int acidityValue) {
    final profile = _profile;

    if (profile != null) {
      if (profile.preferredBeanTaste.acidity == acidityValue) {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(acidity: 0));
      } else {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(acidity: acidityValue));
      }
      notifyListeners();
    }
  }

  onSelectBitternessValue(int bitternessValue) {
    final profile = _profile;

    if (profile != null) {
      if (profile.preferredBeanTaste.bitterness == bitternessValue) {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(bitterness: 0));
      } else {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(bitterness: bitternessValue));
      }
      notifyListeners();
    }
  }

  onSelectSweetValue(int sweetValue) {
    final profile = _profile;

    if (profile != null) {
      if (profile.preferredBeanTaste.sweetness == sweetValue) {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(sweetness: 0));
      } else {
        _profile = profile.copyWith(preferredBeanTaste: profile.preferredBeanTaste.copyWith(sweetness: sweetValue));
      }
      notifyListeners();
    }
  }

  Future<void> onSave() async {
    final profile = _profile;

    if (profile != null) {
      final Map<String, dynamic> jsonMap = {};

      writeNotNull(String key, dynamic value) {
        if (value != null) {
          jsonMap[key] = value;
        }
      }

      writeNotNull('coffee_life', _coffeeLifeToJson(selectedCoffeeLife ?? []));
      writeNotNull('preferred_bean_taste', _preferredBeanTasteToJson());
      writeNotNull('is_certificated', isCertificated);

      if (jsonMap.isNotEmpty) {
        return _api.updateMyProfile(body: {'user_detail': jsonMap});
      }
    }
  }

  String? _coffeeLifeToJson(List<CoffeeLife> coffeeLife) {
    if (coffeeLife.isEmpty) {
      return null;
    } else {
      return coffeeLife.map((e) => e.jsonKey).join(', ');
    }
  }

  String? _preferredBeanTasteToJson() {
    return 'body: ${bodyValue ?? 0}, acidity: ${acidityValue ?? 0}, sweetness: ${sweetnessValue ?? 0}, bitterness: ${bitternessValue ?? 0}';
  }
}
