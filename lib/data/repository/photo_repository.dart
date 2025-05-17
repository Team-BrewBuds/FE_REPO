import 'dart:async';

import 'package:brew_buds/data/repository/permission_repository.dart';
import 'package:brew_buds/domain/photo/model/asset_album.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoRepository {
  PhotoRepository._();

  static final PhotoRepository _instance = PhotoRepository._();

  static PhotoRepository get instance => _instance;

  factory PhotoRepository() => instance;

  List<AssetAlbum> _albumList = List.empty(growable: true);

  List<AssetAlbum> get albumList => List.unmodifiable(_albumList);

  final StreamController<List<AssetAlbum>> _albumStreamController = StreamController.broadcast();

  Stream<List<AssetAlbum>> get albumStream => _albumStreamController.stream;

  Future<void> initState() async {
    await fetchAssetPathList();
  }

  fetchAssetPathList() async {
    final permission = await PermissionRepository.instance.photos;
    switch (permission) {
      case PermissionStatus.granted:
        final assetPathList =
            await PhotoManager.getAssetPathList(type: RequestType.image).onError((_, __) => List.empty(growable: true));
        await setAlbumWithAssetPathList(assetPathList: assetPathList);
        break;
      case PermissionStatus.limited:
        final assetPathList = await PhotoManager.getAssetPathList(type: RequestType.image)
            .then((results) => results.where((result) => result.isAll).toList())
            .onError((_, __) => List.empty(growable: true));
        await setAlbumWithAssetPathList(assetPathList: assetPathList);
        break;
      default:
        return;
    }
  }

  setAlbumWithAssetPathList({required List<AssetPathEntity> assetPathList}) async {
    final List<AssetAlbum> newAlumList = List.empty(growable: true);

    for (final assetPath in assetPathList) {
      final count = await assetPath.assetCountAsync;
      if (count > 0 || assetPath.isAll) {
        final images =
            await assetPath.getAssetListRange(start: 0, end: count).onError((_, __) => List.empty(growable: true));
        newAlumList.add(AssetAlbum(assetPathEntity: assetPath, images: images));
      }
    }

    _albumList = newAlumList;
  }

  Future<void> reSelectPhotos() async {
    await PhotoManager.presentLimited(type: RequestType.image);
    await fetchAssetPathList();
  }
}
