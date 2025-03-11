import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/photo/model/album.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

typedef AlbumTitleState = ({List<Album> albumList, Album? currentAlbum});

typedef ImageViewState = ({List<AssetEntity> images, List<AssetEntity> selectedImages});

class PhotoPresenter extends ChangeNotifier {
  final PermissionStatus _permissionState;
  List<Album> _albumList = [];
  List<AssetEntity> _currentAlbumImages = [];
  List<AssetEntity> _selectedImages = [];
  List<Uint8List> _selectedImagesData = [];
  int _currentPage = 0;
  int _currentAlbumIndex = 0;
  final bool canMultiSelect;

  PhotoPresenter({
    required PermissionStatus permissionStatus,
    this.canMultiSelect = true,
  }) : _permissionState = permissionStatus;

  String get title => _albumList.elementAtOrNull(_currentAlbumIndex)?.name ?? '최근 항목';

  AlbumTitleState get albumTitleState => (
        albumList: _albumList,
        currentAlbum: _albumList.elementAtOrNull(_currentAlbumIndex),
      );

  List<AssetEntity> get selectedImages => _selectedImages;

  List<Uint8List> get selectedImagesData => _selectedImagesData;

  ImageViewState get imageViewState => (
        images: _currentAlbumImages,
        selectedImages: _selectedImages,
      );

  AssetEntity? get preview => _selectedImages.firstOrNull;

  initState() {
    if (_permissionState.isGranted || _permissionState.isLimited) {
      fetchAlbums();
    }
  }

  onRefresh() {
    if (_permissionState.isGranted || _permissionState.isLimited) {
      fetchAlbums();
    }
  }

  /// 앨범 불러오기
  fetchAlbums({bool isReSelected = false}) {
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
      fetchPhotos(albumChange: true, isReSelected: isReSelected);
    });
  }

  /// 앨범 내 사진 불러오기
  fetchPhotos({bool albumChange = false, bool isReSelected = false}) {
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
          if (isReSelected) {
            checkSelectedImagesContain();
          }
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

  Future<Result<String>> onSelectedImage(AssetEntity image) async {
    final data = await image.originBytes;
    if (data != null) {
      if (!canMultiSelect) {
        if (_selectedImages.contains(image)) {
          _selectedImages = List.empty();
          _selectedImagesData = List.empty();
        } else {
          _selectedImages = List.from([image]);
          _selectedImagesData = List.from([data]);
        }
        notifyListeners();
      } else {
        final index = _selectedImages.indexOf(image);
        if (index != -1) {
          _selectedImages = List.from(_selectedImages)..removeAt(index);
          _selectedImagesData = List.from(_selectedImagesData)..removeAt(index);
        } else {
          if (_selectedImages.length < 10) {
            _selectedImages = List.from(_selectedImages)..add(image);
            _selectedImagesData = List.from(_selectedImagesData)..add(data);
          } else {
            return Result.error('사진은 10개이상 선택할 수 없습니다.');
          }
        }
        notifyListeners();
      }
    } else {
      return Result.error('Image 불러오기 실패');
    }

    return Result.success('사진 선택 완료.');
  }

  reselectedImage() {
    PhotoManager.presentLimited(type: RequestType.image).then((value) {
      fetchAlbums();
    });
  }

  checkSelectedImagesContain() {
    if (_permissionState.isLimited) {
      _selectedImages = List.from(_selectedImages)..removeWhere((image) => !_currentAlbumImages.contains(image));
      notifyListeners();
    }
  }
}
