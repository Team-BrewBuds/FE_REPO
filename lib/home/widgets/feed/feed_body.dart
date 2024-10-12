part of 'feed.dart';

sealed class FeedBody {
  factory FeedBody.post({
    required String tag,
    required String title,
    required String bodyText,
    required void Function() onTapMoreButton,
  }) = PostBody;

  factory FeedBody.postWithImagesBody({
    required String tag,
    required String title,
    required String bodyText,
    required int itemLength,
    required Widget Function(BuildContext context, int currentIndex) imageBuilder,
    required void Function() onTapMoreButton,
  }) = PostWithImagesBody;

  factory FeedBody.postWithSharedTastingRecordsBody({
    required String tag,
    required String title,
    required String bodyText,
    required int itemLength,
    required Widget Function(BuildContext context, int currentIndex) tastingRecordBuilder,
    required Widget Function(BuildContext context, int currentIndex) tastingRecordButtonBuilder,
    required void Function() onTapMoreButton,
  }) = PostWithSharedTastingRecordsBody;

  factory FeedBody.tastingRecordBody({
    required String imageUri,
    required String gPA,
    required String type,
    required String name,
    required List<String> tags,
    required String bodyText,
    required void Function() onTapMoreButton,
  }) = TastingRecordBody;
}

final class PostBody implements FeedBody {
  final String tag;
  final String title;
  final String bodyText;
  final void Function() onTapMoreButton;

  PostBody({
    required this.tag,
    required this.title,
    required this.bodyText,
    required this.onTapMoreButton,
  });
}

final class PostWithImagesBody implements FeedBody {
  final String tag;
  final String title;
  final String bodyText;
  final int itemLength;
  final Widget Function(BuildContext context, int currentIndex) imageBuilder;
  final void Function() onTapMoreButton;

  PostWithImagesBody({
    required this.tag,
    required this.title,
    required this.bodyText,
    required this.itemLength,
    required this.imageBuilder,
    required this.onTapMoreButton,
  });
}

final class PostWithSharedTastingRecordsBody implements FeedBody {
  final String tag;
  final String title;
  final String bodyText;
  final int itemLength;
  final Widget Function(BuildContext context, int currentIndex) tastingRecordBuilder;
  final Widget Function(BuildContext context, int currentIndex) tastingRecordButtonBuilder;
  final void Function() onTapMoreButton;

  PostWithSharedTastingRecordsBody({
    required this.tag,
    required this.title,
    required this.bodyText,
    required this.itemLength,
    required this.tastingRecordBuilder,
    required this.tastingRecordButtonBuilder,
    required this.onTapMoreButton,
  });
}

final class TastingRecordBody implements FeedBody {
  final String imageUri;
  final String gPA;
  final String type;
  final String name;
  final List<String> tags;
  final String bodyText;
  final void Function() onTapMoreButton;

  TastingRecordBody({
    required this.imageUri,
    required this.gPA,
    required this.type,
    required this.name,
    required this.tags,
    required this.bodyText,
    required this.onTapMoreButton,
  });
}
