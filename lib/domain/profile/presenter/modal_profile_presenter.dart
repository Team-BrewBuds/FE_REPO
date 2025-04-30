import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/domain/profile/presenter/profile_presenter.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';

final class ModalProfilePresenter extends ProfilePresenter {
  final FollowApi _followApi = FollowApi();
  final BlockApi _blockApi = BlockApi();
  late final StreamSubscription _userFollowSub;

  ModalProfilePresenter({required super.id}) {
    _userFollowSub = EventBus.instance.on<UserFollowEvent>().listen(onUserFollowEvent);
  }

  bool get canShowTastingReport => (profile?.tastedRecordCnt ?? 0) >= 1;

  bool get isFollow => profile?.isUserFollowing ?? false;

  bool get isMine => id == AccountRepository.instance.id;

  @override
  dispose() {
    _userFollowSub.cancel();
    super.dispose();
  }

  onUserFollowEvent(UserFollowEvent event) {
    if (event.senderId != presenterId && event.userId == id && profile != null) {
      profile = profile?.copyWith(isUserFollowing: event.isFollow);
      notifyListeners();
    }
  }

  @override
  Future<void> fetchProfile() async {
    try {
      profile = await repository.fetchProfile(id: id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> onTappedFollowButton() async {
    final isFollow = this.isFollow;
    profile = profile?.copyWith(isUserFollowing: !isFollow);
    notifyListeners();

    try {
      if (isFollow) {
        await _followApi.unFollow(id: id);
      } else {
        await _followApi.follow(id: id);
      }
    } catch (e) {
      profile = profile?.copyWith(isUserFollowing: isFollow);
      notifyListeners();
    }
  }

  Future<bool> onTappedBlockButton() {
    return _blockApi.block(id: id).then((_) => true);
  }
}
