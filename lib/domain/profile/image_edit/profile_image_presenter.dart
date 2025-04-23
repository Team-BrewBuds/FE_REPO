import 'dart:convert';
import 'dart:typed_data';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/photo_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:brew_buds/model/events/profile_update_event.dart';

final class ProfileImagePresenter extends Presenter {
  final PhotoRepository _photoRepository = PhotoRepository.instance;
  final PhotoApi _photoApi = PhotoApi();
  final List<AssetAlbum> _albumList = List.empty(growable: true);
  final String currentImageUrl;
  int? _selectedImageIndex;
  int _selectedAlbumIndex = 0;
  bool _isLoading = false;

  List<AssetAlbum> get albumList => List.unmodifiable(_albumList);

  AssetAlbum? get selectedAlbum => _albumList.elementAtOrNull(_selectedAlbumIndex);

  bool get isLoading => _isLoading;

  Future<Uint8List?> get preView {
    final selectedIndex = _selectedImageIndex;
    final currentAlbum = selectedAlbum;
    if (selectedIndex != null && currentAlbum != null) {
      return currentAlbum.images[selectedIndex].originBytes;
    } else {
      return Future.value(null);
    }
  }

  int? get selectedImageIndex => _selectedImageIndex;

  bool get isSelect => _selectedImageIndex != null;

  ProfileImagePresenter({
    required this.currentImageUrl,
  }) {
    initState();
  }

  initState() {
    _albumList.addAll(_photoRepository.albumList);
    notifyListeners();
  }

  reset() {
    _selectedImageIndex = null;
    _selectedAlbumIndex = 0;
    notifyListeners();
  }

  onSelectPhotoAt(int index) {
    if (index != _selectedImageIndex) {
      _selectedImageIndex = index;
    } else {
      _selectedImageIndex = null;
    }
    notifyListeners();
  }

  onChangeAlbum(int index) {
    if (albumList.length > index) {
      _selectedImageIndex = null;
      _selectedAlbumIndex = index;
      notifyListeners();
    }
  }

  Future<void> onTapReSelectPhoto() async {
    _isLoading = true;
    notifyListeners();

    await _photoRepository.reSelectPhotos();
    _albumList.clear();
    _albumList.addAll(_photoRepository.albumList);
    _selectedImageIndex = null;
    _selectedAlbumIndex = 0;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> onSave(Uint8List data) async {
    try {
      _isLoading = true;
      notifyListeners();

      final result = jsonDecode(await _photoApi.createProfilePhoto(imageData: data)) as Map<String, dynamic>;
      EventBus.instance.fire(
        ProfileImageUpdateEvent(
          senderId: presenterId,
          userId: AccountRepository.instance.id ?? 0,
          imageUrl: result['photo_url'] as String,
        ),
      );
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
