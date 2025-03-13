import 'dart:typed_data';

import 'package:flutter/foundation.dart';

sealed class Photo {
  factory Photo.withUrl({required String url}) = PhotoWithUrl;

  factory Photo.withData({required Uint8List data}) = PhotoWithData;
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
