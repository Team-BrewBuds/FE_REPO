import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:photo_manager/photo_manager.dart';

sealed class Photo {
  factory Photo.withUrl({required String url}) = PhotoWithUrl;
  factory Photo.withData({required Uint8List data}) = PhotoWithData;
  // factory Photo.fromAlbum({required AssetEntity assetEntity}) = PhotoFromAlbum;
  // factory Photo.takenCamera({required Uint8List data}) = PhotoTakenCamera;
}

final class PhotoWithUrl implements Photo {
  final String url;

  const PhotoWithUrl({
    required this.url,
  });
}

final class PhotoWithData implements Photo {
  final Uint8List data;

  const PhotoWithData({
    required this.data,
  });
}
//
// final class PhotoFromAlbum implements Photo {
//   final AssetEntity assetEntity;
//
//   const PhotoFromAlbum({
//     required this.assetEntity,
//   });
// }
//
// final class PhotoTakenCamera implements Photo {
//   final Uint8List data;
//
//   const PhotoTakenCamera({
//     required this.data,
//   });
// }