import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/features/signup/models/coffee_life.dart';
import 'package:flutter/foundation.dart';

final class EditProfilePresenter extends ChangeNotifier {
  final ProfileApi _profileApi = ProfileApi();
  String _imageUri;
  List<CoffeeLife> _selectedCoffeeLifeList;
  String _nickname;
  String _introduction;
  String _link;

  String get imageUri => _imageUri;

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  int get introductionCount => _introduction.length;

  bool get hasLink => _link.isNotEmpty;

  EditProfilePresenter({
    required List<CoffeeLife> selectedCoffeeLifeList,
    required String imageUri,
    required String nickname,
    required String introduction,
    required String link,
  })  : _imageUri = imageUri,
        _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList),
        _nickname = nickname,
        _introduction = introduction,
        _link = link;

  onChangeImageUri(String imageUri) {
    _imageUri = imageUri;
    notifyListeners();
  }

  onChangeNickname(String nickname) {
    _nickname = nickname;
    notifyListeners();
  }

  onChangeIntroduction(String introduction) {
    _introduction = introduction;
    notifyListeners();
  }

  onChangeLink(String link) {
    _link = link;
    notifyListeners();
  }

  onChangeSelectedCoffeeLife(List<CoffeeLife> coffeeLifeList) {
    _selectedCoffeeLifeList = List.from(coffeeLifeList);
    notifyListeners();
  }

  onSave() async {
    final Map<String, dynamic> jsonMap = {};

    writeNotNull(String key, dynamic value) {
      if (value != null) {
        jsonMap[key] = value;
      }
    }

    writeNotNull('introduction', _introduction);
    writeNotNull('profile_link', _link);
    writeNotNull('coffee_life', _coffeeLifeToJson(_selectedCoffeeLifeList));

    if (jsonMap.isNotEmpty) {
      return _profileApi.updateMyProfile(body: {'nickname': _nickname, 'user_detail': jsonMap});
    }
  }

  String? _coffeeLifeToJson(List<CoffeeLife> coffeeLife) {
    if (coffeeLife.isEmpty) {
      return null;
    } else {
      return coffeeLife.map((e) => e.jsonKey).join(', ');
    }
  }
}
