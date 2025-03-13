import 'package:photo_manager/photo_manager.dart';

sealed class Photo {
  factory Photo.fromAlbum({required List<AssetEntity> assetEntity}) = PhotoFromAlbum;
  factory Photo.takenCamera({required String path}) = PhotoTakenCamera;
}

final class PhotoFromAlbum implements Photo {
  final List<AssetEntity> assetEntity;

  const PhotoFromAlbum({
    required this.assetEntity,
  });
}

final class PhotoTakenCamera implements Photo {
  final String path;

  const PhotoTakenCamera({
    required this.path,
  });
}