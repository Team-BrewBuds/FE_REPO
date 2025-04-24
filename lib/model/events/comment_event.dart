import 'package:brew_buds/model/comments.dart';

sealed class CommentEvent {
  String get senderId;
  int get id;
}

final class CommentLikeEvent implements CommentEvent {
  @override
  final String senderId;
  @override
  final int id;
  final bool isLiked;
  final int likeCount;

  const CommentLikeEvent({
    required this.senderId,
    required this.id,
    required this.isLiked,
    required this.likeCount,
  });
}

final class CreateCommentEvent implements CommentEvent {
  @override
  final String senderId;
  @override
  final int id;
  final Comment newComment;

  const CreateCommentEvent({
    required this.senderId,
    required this.id,
    required this.newComment,
  });
}

final class CreateReCommentEvent implements CommentEvent {
  @override
  final String senderId;
  @override
  final int id;
  final Comment newReComment;

  const CreateReCommentEvent({
    required this.senderId,
    required this.id,
    required this.newReComment,
  });
}

final class OnChangeCommentCountEvent implements CommentEvent {
  @override
  final String senderId;
  @override
  final int id;
  final int count;
  final String objectType;

  const OnChangeCommentCountEvent({
    required this.senderId,
    required this.id,
    required this.count,
    required this.objectType,
  });
}