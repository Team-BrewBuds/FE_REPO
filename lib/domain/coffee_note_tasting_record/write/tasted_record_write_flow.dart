import 'dart:typed_data';

sealed class TastedRecordWriteFlow {
  factory TastedRecordWriteFlow.albumSelect() = AlbumSelectStep;

  factory TastedRecordWriteFlow.albumEditStep(List<Uint8List> selectedImages) = AlbumEditStep;

  factory TastedRecordWriteFlow.imageSelectWithCamera() = ImageSelectWithCamera;

  factory TastedRecordWriteFlow.writeFirstStep() = WriteFirstStep;

  factory TastedRecordWriteFlow.writeSecondStep() = WriteSecondStep;

  factory TastedRecordWriteFlow.writeLastStep() = WriteLastStep;
}

sealed class ImageSelectStep implements TastedRecordWriteFlow {}

sealed class ImageSelectWithAlbum implements ImageSelectStep {}

final class AlbumSelectStep implements ImageSelectWithAlbum {}

final class AlbumEditStep implements ImageSelectWithAlbum {
  final List<Uint8List> selectedImages;

  AlbumEditStep(this.selectedImages);
}

final class ImageSelectWithCamera implements ImageSelectStep {}

final class WriteFirstStep implements TastedRecordWriteFlow {}

final class WriteSecondStep implements TastedRecordWriteFlow {}

final class WriteLastStep implements TastedRecordWriteFlow {}
