import 'package:brew_buds/model/post/post_subject.dart';

sealed class NotedObject {
  factory NotedObject.post({
    required int id,
    required String author,
    required PostSubject subject,
    required String title,
    required String createdAt,
    String? imageUrl,
  }) = NotedPost;

  factory NotedObject.tastedRecord({
    required int id,
    required String beanName,
    required List<String> flavor,
    required String imageUrl,
  }) = NotedTastedRecord;
}

final class NotedPost implements NotedObject {
  final int id;
  final String author;
  final PostSubject subject;
  final String title;
  final String createdAt;
  final String? imageUrl;

  const NotedPost({
    required this.id,
    required this.author,
    required this.subject,
    required this.title,
    required this.createdAt,
    this.imageUrl,
  });
}

final class NotedTastedRecord implements NotedObject {
  final int id;
  final String beanName;
  final List<String> flavor;
  final String imageUrl;

  const NotedTastedRecord({
    required this.id,
    required this.beanName,
    required this.flavor,
    required this.imageUrl,
  });
}
