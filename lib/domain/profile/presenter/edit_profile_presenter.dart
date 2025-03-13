import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/api/profile_api.dart';
import 'package:brew_buds/data/mapper/common/coffee_life_mapper.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:flutter/foundation.dart';

typedef ProfileImageState = ({String imageUrl, Uint8List? imageData});

final class EditProfilePresenter extends ChangeNotifier {
  final PhotoApi _photoApi = PhotoApi();
  final ProfileApi _profileApi = ProfileApi();
  String _imageUri;
  List<CoffeeLife> _selectedCoffeeLifeList;
  String _nickname;
  String _introduction;
  String _link;
  Uint8List? _imageData;

  String get imageUri => _imageUri;

  ProfileImageState get profileImageState => (imageUrl: _imageUri, imageData: _imageData);

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

  onChangeImageData(Uint8List imageData) {
    _imageData = imageData;
    notifyListeners();
  }

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

  Future<Result<String>> onSave() async {
    final Map<String, dynamic> jsonMap = {};

    writeNotNull(String key, dynamic value) {
      if (value != null) {
        jsonMap[key] = value;
      }
    }

    writeNotNull('introduction', _introduction);
    writeNotNull('profile_link', _link);
    writeNotNull('coffee_life', _coffeeLifeToJson(_selectedCoffeeLifeList));

    var imageData = _imageData;
    if (imageData != null) {
      final imageResult = await _photoApi
          .createProfilePhoto(imageData: await compressList(imageData))
          .onError((error, stackTrace) => '');
      if (imageResult.isEmpty) {
        return Result.error('프로필 이미지 등록 실패.');
      }
    }

    if (jsonMap.isNotEmpty) {
      return _profileApi
          .updateMyProfile(body: {'nickname': _nickname, 'user_detail': jsonMap})
          .then((value) => Result.success('프로필 수성 성공.'))
          .onError((error, stackTrace) => Result.error('프로필 수정 실패.'));
    }

    return Result.error('프로필 수정 실패.');
  }

  String? _coffeeLifeToJson(List<CoffeeLife> coffeeLife) {
    if (coffeeLife.isEmpty) {
      return null;
    } else {
      return coffeeLife.map((e) => e.toJson).join(', ');
    }
  }
}
