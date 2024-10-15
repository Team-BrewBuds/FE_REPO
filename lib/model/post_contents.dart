import 'package:brew_buds/model/tasting_record_share_mixin.dart';

sealed class PostContents {
  factory PostContents.onlyText() = OnlyText;

  factory PostContents.images(List<String> imageUriList) = ImageList;

  factory PostContents.tastingRecord(List<TastingRecordShareMixin> sharedTastingRecordList) = SharedTastingRecordList;
}

final class OnlyText implements PostContents {}

final class ImageList implements PostContents {
  final List<String> imageUriList;

  ImageList(this.imageUriList);
}

final class SharedTastingRecordList implements PostContents {
  final List<TastingRecordShareMixin> sharedTastingRecordList;

  SharedTastingRecordList(this.sharedTastingRecordList);
}