import 'package:brew_buds/model/feed.dart';
import 'package:brew_buds/model/post_contents.dart';
import 'package:brew_buds/model/post_tag.dart';

final class Post extends Feed {
  final PostTag tag;
  final String title;
  final String body;
  final PostContents contents;

  Post({
    required super.writer,
    required super.writingTime,
    required super.hits,
    required super.likeCount,
    required super.commentsCount,
    required super.isLike,
    required super.isLeaveComment,
    required super.isSaved,
    required this.tag,
    required this.title,
    required this.body,
    required this.contents,
  });
}
