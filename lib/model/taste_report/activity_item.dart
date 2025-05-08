import 'package:brew_buds/model/post/post_subject.dart';

sealed class ActivityItem {
  factory ActivityItem.post({
    required int id,
    required String title,
    required String author,
    required PostSubject subject,
    required String thumbnail,
    required String createdAt,
  }) = PostActivityItem;

  factory ActivityItem.tastedRecord({
    required int id,
    required String beanName,
    required double rating,
    required List<String> flavors,
    required String thumbnail,
  }) = TastedRecordActivityItem;

  factory ActivityItem.coffeeBean({
    required int id,
    required String name,
    required double rating,
    required String imagePath,
  }) = SavedBeanActivityItem;
}

final class PostActivityItem implements ActivityItem {
  final int id;
  final String title;
  final String author;
  final PostSubject subject;
  final String thumbnail;
  final String createdAt;

  const PostActivityItem({
    required this.id,
    required this.title,
    required this.author,
    required this.subject,
    required this.thumbnail,
    required this.createdAt,
  });
}

final class TastedRecordActivityItem implements ActivityItem {
  final int id;
  final String beanName;
  final double rating;
  final List<String> flavors;
  final String thumbnail;

  const TastedRecordActivityItem({
    required this.id,
    required this.beanName,
    required this.rating,
    required this.flavors,
    required this.thumbnail,
  });
}

final class SavedBeanActivityItem implements ActivityItem {
  final int id;
  final String name;
  final double rating;
  final String imagePath;

  const SavedBeanActivityItem({
    required this.id,
    required this.name,
    required this.rating,
    required this.imagePath,
  });
}
