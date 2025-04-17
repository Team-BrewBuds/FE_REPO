import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';

final class PopularPostPresenter extends Presenter {
  late final StreamSubscription _postSub;
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
    _postSub = EventBus.instance.on<PostEvent>().listen(_onEvent);
  }

  @override
  dispose() {
    _postSub.cancel();
    super.dispose();
  }

  _onEvent(PostEvent event) {
    switch (event) {
      case PostUpdateEvent():
        final post = event.post;
        if (post.id == _post.id) {
          _post = _post.copyWith(
            title: post.title,
            subject: post.subject,
            contents: post.contents,
            tag: post.tag,
          );
          notifyListeners();
        }
        break;
      default:
        break;
    }
  }
}
