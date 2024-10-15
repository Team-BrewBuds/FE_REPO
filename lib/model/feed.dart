import 'package:brew_buds/model/user.dart';

abstract class Feed {
  final User writer;
  final DateTime writingTime;
  final int hits;
  final int likeCount;
  final int commentsCount;
  final bool isLike;
  final bool isLeaveComment;
  final bool isSaved;

  const Feed({
    required this.writer,
    required this.writingTime,
    required this.hits,
    required this.likeCount,
    required this.commentsCount,
    required this.isLike,
    required this.isLeaveComment,
    required this.isSaved,
  });
}