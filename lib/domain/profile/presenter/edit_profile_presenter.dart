import 'dart:async';
import 'dart:typed_data';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/profile_repository.dart';
import 'package:brew_buds/domain/profile/model/profile_update_model.dart';
import 'package:brew_buds/exception/profile_update_exception.dart';
import 'package:brew_buds/model/common/coffee_life.dart';
import 'package:brew_buds/model/events/profile_update_event.dart';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart';

typedef ProfileImageState = ({String imageUrl, Uint8List? imageData});
typedef NicknameValidState = ({
  bool isEditing,
  bool hasNickname,
  bool isValidNicknameLength,
  bool isValidNickname,
  bool isDuplicatingNickname,
  bool isNicknameChecking,
});
typedef LinkState = ({bool isValid, bool hasLink});

final class EditProfilePresenter extends Presenter {
  late final Debouncer<String> _nicknameCheckDebouncer;
  late final StreamSubscription _profileUpdateSub;
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

  bool get canEdit =>
      (_preNickname != _nickname ||
          _preLink != _link ||
          _preIntroduction != _introduction ||
          _compareCoffeeLifeList()) &&
      !_isNicknameChecking &&
      !_isDuplicatingNickname &&
      _nickname.length >= 2 &&
      _nickname.length <= 12 &&
      _isValidUrl(_link);

  String get imageUrl => _imageUrl;

  List<CoffeeLife> get selectedCoffeeLifeList => _selectedCoffeeLifeList;

  NicknameValidState get nicknameValidState => (
        isEditing: _preNickname != _nickname,
        hasNickname: _nickname.isNotEmpty,
        isValidNicknameLength: _nickname.length >= 2 && _nickname.length <= 12,
        isValidNickname: _isValidNickName(),
        isDuplicatingNickname: _isDuplicatingNickname,
        isNicknameChecking: _isNicknameChecking,
      );

  int get introductionCount => _introduction.length;

  LinkState get linkState => (
        isValid: _isValidUrl(_link),
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
        _preLink = link {
    _profileUpdateSub = EventBus.instance.on<ProfileUpdateEvent>().listen(onProfileUpdateEvent);
    _nicknameCheckDebouncer = Debouncer(
      const Duration(milliseconds: 300),
      initialValue: '',
      onChanged: (newNickname) {
        if (newNickname.length >= 2) {
          _checkNickname(newNickname);
        } else {
          _isDuplicatingNickname = false;
          notifyListeners();
        }
      },
    );
  }

  @override
  dispose() {
    _profileUpdateSub.cancel();
    super.dispose();
  }

  onProfileUpdateEvent(ProfileUpdateEvent event) {
    switch (event) {
      case ProfileImageUpdateEvent():
        if (event.senderId != presenterId && AccountRepository.instance.id == event.userId) {
          _imageUrl = event.imageUrl;
          notifyListeners();
        }
      default:
        return;
    }
  }

  _checkNickname(String newNickname) async {
    _isNicknameChecking = true;
    notifyListeners();

    if (newNickname == _preNickname) {
      _isDuplicatingNickname = false;
    } else {
      _isDuplicatingNickname =
          await _profileRepository.isValidNickname(nickname: newNickname).onError((error, stackTrace) => true);
    }

    _isNicknameChecking = false;
    notifyListeners();
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

  bool _isValidUrl(String link) {
    if (link.trim().isEmpty) return true; // 비어 있으면 유효하다고 간주

    final uri = Uri.tryParse(link.trim());
    if (uri == null || !uri.hasScheme || !uri.isAbsolute) return false;

    final hostParts = uri.host.split('.').where((e) => e.trim().isNotEmpty).toList();
    if (hostParts.length < 2) return false;

    return true;
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

  Future<bool> onSave() async {
    if (_preNickname == _nickname &&
        _preIntroduction == _introduction &&
        _preLink == _link &&
        !_compareCoffeeLifeList()) {
      return false;
    }

    if (_nickname.length < 2 || _nickname.length > 12) {
      throw const IsShortNicknameProfileEditException();
    }

    if (_isNicknameChecking) {
      throw const NicknameCheckingProfileEditException();
    }

    if (_isDuplicatingNickname) {
      throw const DuplicateNicknameProfileEditException();
    }

    if (!_isValidNickName()) {
      throw const InvalidNicknameProfileEditException();
    }

    if (_introduction.containsBadWords) {
      throw const IntroductionContainsBadWordsProfileEditException();
    }

    if (!_isValidUrl(_link)) {
      throw const InvalidUrlException();
    }

    final ProfileUpdateModel profileUpdateModel = ProfileUpdateModel(
      nickname: _preNickname != _nickname ? _nickname : null,
      introduction: _preIntroduction != _introduction ? _introduction : null,
      profileLink: _preLink != _link ? _link : null,
      coffeeLife: _compareCoffeeLifeList() ? _selectedCoffeeLifeList : null,
    );

    try {
      await _profileRepository.updateProfile(data: profileUpdateModel.toJson());
      EventBus.instance.fire(
        ProfileDataUpdateEvent(
          senderId: presenterId,
          userId: AccountRepository.instance.id ?? 0,
          profileUpdateModel: profileUpdateModel,
        ),
      );
      return true;
    } catch (e) {
      rethrow;
    }
  }

  bool _isValidNickName() {
    if (_nickname.containsBadWords) {
      return false;
    }

    for (int codeUnit in _nickname.codeUnits) {
      if (codeUnit >= 0x3131 && codeUnit <= 0x318E) {
        return false;
      }
    }
    return true;
  }
}
