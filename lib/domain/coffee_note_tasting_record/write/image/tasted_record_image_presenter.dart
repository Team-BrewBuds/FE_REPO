import 'dart:typed_data';

import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/data/repository/photo_repository.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

final class TastedRecordImagePresenter extends Presenter {
  final int maximumSelectCount = 5;
  final PhotoRepository _photoRepository = PhotoRepository.instance;
  final List<int> _selectedPhotoIndexList = List.empty(growable: true);
  final List<AssetAlbum> _albumList = List.empty(growable: true);
  int _selectedAlbumIndex = 0;

  List<AssetAlbum> get albumList => List.unmodifiable(_albumList);

  List<int> get selectedPhotoIndexList => List.unmodifiable(_selectedPhotoIndexList);

  AssetAlbum? get selectedAlbum => _albumList.elementAtOrNull(_selectedAlbumIndex);

  AssetEntity? get preView => selectedAlbum?.images.elementAtOrNull(_selectedPhotoIndexList.lastOrNull ?? 0);

  Future<PermissionStatus> get status => PermissionRepository.instance.photos;

  TastedRecordImagePresenter() {
    initState();
  }

  initState() {
    _albumList.addAll(_photoRepository.albumList);
    notifyListeners();
  }

  reset() {
    _selectedPhotoIndexList.clear();
    _selectedAlbumIndex = 0;
    notifyListeners();
  }

  Future<void> onSelectPhotoAt(int index) async {
    if (_selectedPhotoIndexList.contains(index)) {
      _selectedPhotoIndexList.remove(index);
    } else {
      if (_selectedPhotoIndexList.length == maximumSelectCount) {
        throw Exception();
      } else {
        _selectedPhotoIndexList.add(index);
      }
    }
    notifyListeners();
  }

  int getOrderOfSelected(int index) {
    return _selectedPhotoIndexList.indexWhere((e) => e == index);
  }

  Future<List<Uint8List?>> getSelectedPhotoData() async {
    final currentAlbum = selectedAlbum;
    if (currentAlbum != null) {
      return await Future.wait(_selectedPhotoIndexList.map((index) => currentAlbum.images[index].originBytes));
    } else {
      return await Future.value(List.empty());
    }
  }

  onChangeAlbum(int index) {
    if (albumList.length > index) {
      _selectedPhotoIndexList.clear();
      _selectedAlbumIndex = index;
      notifyListeners();
    }
  }

  Future<void> onTapReSelectPhoto() async {
    await _photoRepository.reSelectPhotos();
    _albumList.clear();
    _albumList.addAll(_photoRepository.albumList);
    _selectedPhotoIndexList.clear();
    _selectedAlbumIndex = 0;
    notifyListeners();
  }
}
