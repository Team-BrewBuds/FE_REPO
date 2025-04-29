import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/feed/feed.dart';

typedef AuthorState = ({String imageUrl, String nickname, String createdAt, int viewCount, bool isFollow, bool isMine});
typedef BottomButtonState = ({int likeCount, bool isLiked, int commentsCount, bool isSaved});

abstract class FeedPresenter<T extends Feed> extends Presenter {
  T feed;
  late final StreamSubscription _userFollowSub;

  FeedPresenter({
    required this.feed,
  }) {
    _userFollowSub = EventBus.instance.on<UserFollowEvent>().listen(onUserFollowEvent);
  }

  @override
  dispose() {
    _userFollowSub.cancel();
    super.dispose();
  }

  AuthorState get authorState;

  BottomButtonState get bottomButtonState;

  onUserFollowEvent(UserFollowEvent event);

  Future<void> onLikeButtonTap();

  Future<void> onSaveButtonTap();

  Future<void> onFollowButtonTap();
}
