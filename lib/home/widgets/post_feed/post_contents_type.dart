sealed class PostContentsType {
  factory PostContentsType.onlyText() = OnlyTextContents;

  factory PostContentsType.images({required List<String> imageUriList}) = ImagesContents;

  factory PostContentsType.tastingRecords({
    required List<TastingRecordContent> sharedTastingRecords,
  }) = TastingRecordContents;
}

final class OnlyTextContents implements PostContentsType {}

final class ImagesContents implements PostContentsType {
  final List<String> imageUriList;

  const ImagesContents({
    required this.imageUriList,
  });
}

typedef TastingRecordContent = ({
  String thumbnailUri,
  String coffeeBeanType,
  String name,
  String body,
  double rating,
  List<String> tags,
});

final class TastingRecordContents implements PostContentsType {
  final List<TastingRecordContent> sharedTastingRecords;

  const TastingRecordContents({
    required this.sharedTastingRecords,
  });
}
