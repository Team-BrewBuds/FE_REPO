import 'dart:typed_data';

import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/model/common/coffee_life.dart';

typedef ProfileImageState = ({String imageUrl, Uint8List? imageData});

final class EditProfilePresenter extends Presenter {
  final PhotoApi _photoApi = PhotoApi();
  final ProfileRepository _profileRepository = ProfileRepository.instance;
  String _imageUrl;
  List<CoffeeLife> _selectedCoffeeLifeList;
  String _nickname;
  String _introduction;
  String _link;
  Uint8List? _imageData;

  String get imageUri => _imageUrl;

  ProfileImageState get profileImageState => (imageUrl: _imageUrl, imageData: _imageData);

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  int get introductionCount => _introduction.length;

  bool get hasLink => _link.isNotEmpty;

  EditProfilePresenter({
    required List<CoffeeLife> selectedCoffeeLifeList,
    required String imageUrl,
    required String nickname,
    required String introduction,
    required String link,
  })  : _imageUrl = imageUrl,
        _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList),
        _nickname = nickname,
        _introduction = introduction,
        _link = link;

  onChangeImageData(Uint8List imageData) {
    _imageData = imageData;
    notifyListeners();
  }

  onChangeImageUri(String imageUri) {
    _imageUrl = imageUri;
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
    final imageData = _imageData;
    if (imageData != null) {
      final imageResult = await _photoApi
          .createProfilePhoto(imageData: await compressList(imageData))
          .onError((error, stackTrace) => '');
      if (imageResult.isEmpty) {
        return Result.error('프로필 이미지 등록 실패.');
      }
    }

    return _profileRepository
        .updateProfile(
          introduction: _introduction,
          profileLink: _link,
          coffeeLife: _selectedCoffeeLifeList,
        )
        .then((value) => Result.success('프로필 수성 성공.'))
        .onError((error, stackTrace) => Result.error('프로필 수정 실패.'));
  }
}
