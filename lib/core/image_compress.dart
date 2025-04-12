import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressList(Uint8List list) async {
  int minHeight = 1024;
  int minWidth = 1024;
  int maxLength = 1024 * 1024;
  Uint8List result = list;

  while (result.length > maxLength) {
    result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: minHeight,
      minWidth: minWidth,
      quality: 90,
      format: CompressFormat.png,
    );
    minHeight = (minHeight * 0.9).round();
    minWidth = (minWidth * 0.9).round();
  }
  return result;
}
