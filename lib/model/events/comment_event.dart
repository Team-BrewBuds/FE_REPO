import 'package:brew_buds/model/comments.dart';

sealed class CommentEvent {
  String get senderId;
}

final class CommentLikeEvent implements CommentEvent {
  @override
  final String senderId;
  final int commentId;
  final bool isLiked;
  final int likeCount;

  const CommentLikeEvent({
    required this.senderId,
    required this.commentId,
    required this.isLiked,
    required this.likeCount,
  });
}

final class CreateCommentEvent implements CommentEvent {
  @override
  final String senderId;
  final int objectId;
  final String objectType;
  final Comment newComment;

  const CreateCommentEvent({
    required this.senderId,
    required this.objectId,
    required this.objectType,
    required this.newComment,
  });
}

final class CreateReCommentEvent implements CommentEvent {
  @override
  final String senderId;
  final int parentId;
  final int objectId;
  final String objectType;
  final Comment newReComment;

  const CreateReCommentEvent({
    required this.senderId,
    required this.parentId,
    required this.objectId,
    required this.objectType,
    required this.newReComment,
  });
}

final class OnChangeCommentCountEvent implements CommentEvent {
  @override
  final String senderId;
  final int count;
  final int objectId;
  final String objectType;

  const OnChangeCommentCountEvent({
    required this.senderId,
    required this.count,
    required this.objectId,
    required this.objectType,
  });
}
