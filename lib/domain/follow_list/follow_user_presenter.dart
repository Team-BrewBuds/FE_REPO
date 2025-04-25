import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/domain/follow_list/model/follow_user.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';

final class FollowUserPresenter extends Presenter {
  final FollowApi _followApi = FollowApi();
  late final StreamSubscription _userFollowSub;
  FollowUser _user;

  String get imageUrl => _user.profileImageUrl;

  String get nickname => _user.nickname;

  bool get isFollow => _user.isFollowing;

  FollowUserPresenter({
    required FollowUser user,
  }) : _user = user {
    _userFollowSub = EventBus.instance.on<UserFollowEvent>().listen(onUserFollowEvent);
  }

  @override
  dispose() {
    _userFollowSub.cancel();
    super.dispose();
  }

  onUserFollowEvent(UserFollowEvent event) {
    if (event.senderId != presenterId && _user.id == event.userId) {
      _user = _user.copyWith(isFollowing: event.isFollow);
      notifyListeners();
    }
  }

  Future<void> follow() async {
    final isFollow = _user.isFollowing;
    _user = _user.copyWith(isFollowing: !isFollow);
    notifyListeners();

    try {
      if (isFollow) {
        await _followApi.unFollow(id: _user.id);
      } else {
        await _followApi.follow(id: _user.id);
      }
      EventBus.instance.fire(
        UserFollowEvent(
          senderId: presenterId,
          userId: _user.id,
          isFollow: !isFollow,
        ),
      );
    } catch (e) {
      _user = _user.copyWith(isFollowing: isFollow);
      notifyListeners();
    }
  }
}
