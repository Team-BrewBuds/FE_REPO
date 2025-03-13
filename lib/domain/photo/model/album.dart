import 'package:photo_manager/photo_manager.dart';

class Album {
  final String id;
  final String name;
  final int imagesCount;
  final AssetEntity thumbnail;

  Album({
    required this.id,
    required this.name,
    required this.imagesCount,
    required this.thumbnail,
  });
}
