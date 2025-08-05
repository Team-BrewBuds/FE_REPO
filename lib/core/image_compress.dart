import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';

Future<Uint8List> compressList(Uint8List list) async {
  return FlutterImageCompress.compressWithList(
    list,
    minHeight: 512,
    minWidth: 512,
    quality: 95,
    format: CompressFormat.jpeg,
  );
}
