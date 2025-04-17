import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/recommended/recommended_user.dart';

final class RecommendedBuddyPresenter extends Presenter {
  final FollowApi _followApi = FollowApi();
  late final StreamSubscription _userFollowSub;
  RecommendedUser _user;

  RecommendedUser get user => _user;

  RecommendedBuddyPresenter({
    required RecommendedUser user,
  }) : _user = user {
    _userFollowSub = EventBus.instance.on<UserFollowEvent>().listen(onUserFollowEvent);
  }

  @override
  dispose() {
    _userFollowSub.cancel();
    super.dispose();
  }

  onUserFollowEvent(UserFollowEvent event) {
    if (event.senderId != presenterId && user.id == event.userId) {
      _user = user.copyWith(
        isFollow: event.isFollow,
        followerCount: event.isFollow ? user.followerCount + 1 : user.followerCount - 1,
      );
      notifyListeners();
    }
  }

  onTapFollow() async {
    final isFollow = user.isFollow;
    final followerCount = user.followerCount;
    _user = _user.copyWith(isFollow: !isFollow, followerCount: isFollow ? followerCount - 1 : followerCount + 1);
    notifyListeners();

    try {
      if (user.isFollow) {
        await _followApi.unFollow(id: user.id);
      } else {
        await _followApi.follow(id: user.id);
      }
      EventBus.instance.fire(UserFollowEvent(senderId: presenterId, userId: user.id, isFollow: !isFollow));
    } catch (e) {
      _user = _user.copyWith(isFollow: isFollow, followerCount: followerCount);
      notifyListeners();
    }
  }
}
