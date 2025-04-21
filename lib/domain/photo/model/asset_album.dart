import 'package:photo_manager/photo_manager.dart';

final class AssetAlbum {
  final AssetPathEntity assetPathEntity;
  final List<AssetEntity> images;

  const AssetAlbum({
    required this.assetPathEntity,
    required this.images,
  });
}