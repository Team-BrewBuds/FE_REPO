import 'dart:typed_data';

import 'package:brew_buds/core/image_compress.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:debounce_throttle/debounce_throttle.dart';

typedef ProfileImageState = ({String imageUrl, Uint8List? imageData});
typedef NicknameState = ({bool isValid, bool isDuplicating, bool isChecking, bool isEditing});
typedef LinkState = ({bool isValid, bool isStartWithHttpOrHttps, bool hasLink});

final class EditProfilePresenter extends Presenter {
  final PhotoApi _photoApi = PhotoApi();
  late final Debouncer<String> _nicknameCheckDebouncer;
  final ProfileRepository _profileRepository = ProfileRepository.instance;
  final List<CoffeeLife> _preCoffeeLife;
  final String _preNickname;
  final String _preIntroduction;
  final String _preLink;

  String _imageUrl;
  List<CoffeeLife> _selectedCoffeeLifeList;
  String _nickname;
  bool _isDuplicatingNickname = false;
  bool _isNicknameChecking = false;
  String _introduction;
  String _link;
  Uint8List? _imageData;

  bool get canEdit =>
      (_preNickname != _nickname ||
          _preLink != _link ||
          _preIntroduction != _introduction ||
          _imageData != null ||
          _compareCoffeeLifeList()) &&
      !_isNicknameChecking &&
      !_isDuplicatingNickname &&
      _nickname.length >= 2 &&
      _nickname.length <= 12 &&
      _isValidUrl() &&
      _isStartWithHttpOrHttps();

  String get imageUri => _imageUrl;

  ProfileImageState get profileImageState => (imageUrl: _imageUrl, imageData: _imageData);

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  NicknameState get nicknameState => (
        isValid: _nickname.length >= 2 && _nickname.length <= 12,
        isDuplicating: _isDuplicatingNickname,
        isChecking: _isNicknameChecking,
        isEditing: _preNickname != _nickname,
      );

  int get introductionCount => _introduction.length;

  LinkState get linkState => (
        isValid: _isValidUrl(),
        isStartWithHttpOrHttps: _isStartWithHttpOrHttps(),
        hasLink: _link.isNotEmpty,
      );

  bool get hasLink => _link.isNotEmpty;

  EditProfilePresenter({
    required List<CoffeeLife> selectedCoffeeLifeList,
    required String imageUrl,
    required String nickname,
    required String introduction,
    required String link,
  })  : _imageUrl = imageUrl,
        _selectedCoffeeLifeList = List.from(selectedCoffeeLifeList),
        _preCoffeeLife = List.from(selectedCoffeeLifeList),
        _nickname = nickname,
        _preNickname = nickname,
        _introduction = introduction,
        _preIntroduction = introduction,
        _link = link,
        _preLink = link;

  initState() {
    _nicknameCheckDebouncer = Debouncer(
      const Duration(seconds: 10),
      initialValue: '',
      onChanged: (newNickname) {
        _checkNickname(newNickname);
      },
    );
  }

  _checkNickname(String newNickname) async {
    if (!_isNicknameChecking && newNickname.length >= 2 && newNickname != _preNickname) {
      _isNicknameChecking = true;
      notifyListeners();
      _isDuplicatingNickname =
          await _profileRepository.isValidNickname(nickname: newNickname).onError((error, stackTrace) => true);
      _isNicknameChecking = false;
      notifyListeners();
    } else if (!_isNicknameChecking && newNickname == _preNickname) {
      _isDuplicatingNickname = false;
      notifyListeners();
    }
  }

  bool _compareCoffeeLifeList() {
    if (_preCoffeeLife.isEmpty && _selectedCoffeeLifeList.isEmpty) {
      return false;
    } else if (_preCoffeeLife.isEmpty && _selectedCoffeeLifeList.isNotEmpty) {
      return true;
    } else if (_preCoffeeLife.length == _selectedCoffeeLifeList.length) {
      return _preCoffeeLife.map((e) => _selectedCoffeeLifeList.contains(e)).where((element) => !element).isNotEmpty;
    } else {
      return true;
    }
  }

  bool _isValidUrl() {
    if (_link.isNotEmpty) {
      final uri = Uri.tryParse(_link);
      return uri != null && uri.host.isNotEmpty;
    } else {
      return true;
    }
  }

  bool _isStartWithHttpOrHttps() {
    if (_link.isNotEmpty) {
      final uri = Uri.tryParse(_link);
      return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
    } else {
      return true;
    }
  }

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
    _nicknameCheckDebouncer.setValue(nickname);
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
          nickname: _preNickname != _nickname ? _nickname : null,
          introduction: _preIntroduction != _introduction ? _introduction : null,
          profileLink: _preLink != _link ? _link : null,
          coffeeLife: _compareCoffeeLifeList() ? _selectedCoffeeLifeList : null,
        )
        .then((value) => Result.success('프로필 수성 성공.'))
        .onError((error, stackTrace) => Result.error('프로필 수정 실패.'));
  }
}
