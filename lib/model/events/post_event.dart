import 'package:brew_buds/domain/coffee_note_post/model/post_update_model.dart';

sealed class PostEvent {
  String get senderId;
}

final class PostCreateEvent implements PostEvent {
  @override
  final String senderId;

  const PostCreateEvent({
    required this.senderId,
  });
}

final class PostDeleteEvent implements PostEvent {
  @override
  final String senderId;
  final int id;

  const PostDeleteEvent({
    required this.senderId,
    required this.id,
  });
}

final class PostUpdateEvent implements PostEvent {
  @override
  final String senderId;
  final int id;
  final PostUpdateModel updateModel;

  const PostUpdateEvent({
    required this.senderId,
    required this.id,
    required this.updateModel,
  });
}

final class PostLikeEvent implements PostEvent {
  @override
  final String senderId;
  final int id;
  final bool isLiked;
  final int likeCount;

  const PostLikeEvent({
    required this.senderId,
    required this.id,
    required this.isLiked,
    required this.likeCount,
  });
}

final class PostSaveEvent implements PostEvent {
  @override
  final String senderId;
  final int id;
  final bool isSaved;

  const PostSaveEvent({
    required this.senderId,
    required this.id,
    required this.isSaved,
  });
}
