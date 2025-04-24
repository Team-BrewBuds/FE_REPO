import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';

final class PopularPostPresenter extends Presenter {
  late final StreamSubscription _postSub;
  late final StreamSubscription _commentSub;
  Post _post;

  int get id => _post.id;

  String get nickName => _post.author.nickname;

  String get title => _post.title;

  String get contents => _post.contents;

  PostSubject get subject => _post.subject;

  String get createdAt => _post.createdAt;

  int get viewCount => _post.viewCount;

  int get likeCount => _post.likeCount;

  int get commentsCount => _post.commentsCount;

  String? get imageUrl => _post.imagesUrl.firstOrNull;

  PopularPostPresenter({
    required Post post,
  }) : _post = post {
    _postSub = EventBus.instance.on<PostEvent>().listen(_onPostEvent);
    _commentSub = EventBus.instance.on<CommentEvent>().listen(_onCommentEvent);
  }

  @override
  dispose() {
    _postSub.cancel();
    _commentSub.cancel();
    super.dispose();
  }

  _onPostEvent(PostEvent event) {
    switch (event) {
      case PostUpdateEvent():
        final updateModel = event.updateModel;
        if (event.id == _post.id) {
          _post = _post.copyWith(
            title: updateModel.title,
            subject: updateModel.subject,
            contents: updateModel.contents,
            tag: updateModel.tag,
          );
          notifyListeners();
        }
        break;
      default:
        break;
    }
  }

  _onCommentEvent(CommentEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case OnChangeCommentCountEvent():
          if (event.id == _post.id && event.objectType == 'post') {
            _post = _post.copyWith(commentsCount: event.count);
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }
}
