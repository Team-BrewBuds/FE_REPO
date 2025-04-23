import 'dart:typed_data';

import 'package:brew_buds/core/presenter.dart';

final class TastedRecordImageEditPresenter extends Presenter {
  final List<Uint8List> _originImages;
  final List<Uint8List> _images;

  List<Uint8List> get images => List.unmodifiable(_images);

  List<Uint8List> get originImages => List.unmodifiable(_originImages);

  TastedRecordImageEditPresenter({
    required List<Uint8List?> images,
  })  : _originImages = List.from(images.whereType<Uint8List>()),
        _images = List.from(images.whereType<Uint8List>());

  onEditedImage({required int index, required Uint8List imageData}) {
    _images[index] = imageData;
    notifyListeners();
  }
}
