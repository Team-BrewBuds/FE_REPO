import 'package:brew_buds/photo/model/album.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

typedef AlbumTitleState = ({List<Album> albumList, Album? currentAlbum});

typedef ImageViewState = ({List<AssetEntity> images, List<AssetEntity> selectedImages});

final class PhotoGridPresenter extends ChangeNotifier {
  final PermissionStatus _permissionState;
  List<Album> _albumList = [];
  List<AssetEntity> _currentAlbumImages = [];
  List<AssetEntity> _selectedImages = [];
  int _currentPage = 0;
  int _currentAlbumIndex = 0;

  PhotoGridPresenter({
    required PermissionStatus permissionStatus,
  }) : _permissionState = permissionStatus;

  String get title => _albumList.elementAtOrNull(_currentAlbumIndex)?.name ?? '최근 항목';

  AlbumTitleState get albumTitleState => (
        albumList: _albumList,
        currentAlbum: _albumList.elementAtOrNull(_currentAlbumIndex),
      );

  List<AssetEntity> get selectedImages => _selectedImages;

  ImageViewState get imageViewState => (
        images: _currentAlbumImages,
        selectedImages: _selectedImages,
      );

  initState() async {
    if (_permissionState.isGranted || _permissionState.isLimited) {
      _fetchAlbums();
    }
  }

  onRefresh() async {}

  checkSelectedImagesContain() {
    if (_permissionState.isLimited) {
      _selectedImages = List.from(_selectedImages)..removeWhere((image) => !_currentAlbumImages.contains(image));
      notifyListeners();
    }
  }

  /// 앨범 불러오기
  _fetchAlbums({Function()? onDone}) {
    PhotoManager.getAssetPathList(type: RequestType.image).then((assetsPathList) async {
      final List<Album> newAlbumList = [];
      for (int i = 0; i < assetsPathList.length; i++) {
        final assetsPath = assetsPathList[i];
        final imagesCount = await assetsPath.assetCountAsync;
        final thumbnail = await assetsPath.getAssetListPaged(page: 0, size: 1);
        if (thumbnail.isNotEmpty) {
          newAlbumList.add(
            Album(
              id: assetsPath.id,
              name: assetsPath.isAll ? '최근 항목' : assetsPath.name,
              imagesCount: imagesCount,
              thumbnail: thumbnail.first,
            ),
          );
        }
      }
      _albumList = List.from(newAlbumList);
      fetchPhotos(albumChange: true, onDone: onDone);
    });
  }

  /// 앨범 내 사진 불러오기
  fetchPhotos({bool albumChange = false, Function()? onDone}) {
    if (_albumList.isEmpty) return;
    if (albumChange) {
      _currentPage = 0;
      _currentAlbumImages = List.empty();
    } else {
      _currentPage++;
    }
    AssetPathEntity.fromId(_albumList[_currentAlbumIndex].id, type: RequestType.image).then(
      (assetPathEntity) {
        assetPathEntity.getAssetListPaged(page: _currentPage, size: 40).then((images) {
          _currentAlbumImages = List.from(_currentAlbumImages)..addAll(images);
          onDone?.call();
          notifyListeners();
        });
      },
    );
  }

  onChangeAlbum(int index) async {
    if (_currentAlbumIndex != index) {
      _currentAlbumIndex = index;
      await fetchPhotos(albumChange: true);
    }
  }

  Future<bool> onSelectedImage(AssetEntity image) async {
    if (_selectedImages.contains(image)) {
      _selectedImages = List.from(_selectedImages)..remove(image);
    } else {
      if (_selectedImages.length < 10) {
        _selectedImages = List.from(_selectedImages)..add(image);
      } else {
        return false;
      }
    }
    notifyListeners();
    return true;
  }

  reselectedImage() {
    PhotoManager.presentLimited(type: RequestType.image).then((value) {
      _fetchAlbums(
        onDone: () {
          checkSelectedImagesContain();
        },
      );
    });
  }
}
