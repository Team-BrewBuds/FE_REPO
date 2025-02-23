import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/profile/model/profile.dart';
import 'package:brew_buds/profile/presenter/profile_presenter.dart';

final class OtherProfilePresenter extends ProfilePresenter {
  final FollowApi _followApi = FollowApi();
  final BlockApi _blockApi = BlockApi();
  final int id;

  bool get isFollow => profile?.isUserFollowing ?? false;

  OtherProfilePresenter({
    required super.repository,
    required this.id,
  });

  @override
  Future<Profile> fetchProfile() {
    return repository.fetchProfile(id: id);
  }

  onTappedFollowButton() {
    if (isFollow) {
      _followApi.unFollow(id: id).then((_) {
        profile = profile?.copyWith(isUserFollowing: false);
        notifyListeners();
      });
    } else {
      _followApi.follow(id: id).then((_) {
        profile = profile?.copyWith(isUserFollowing: true);
        notifyListeners();
      });
    }
  }

  Future<bool> onTappedBlockButton() {
    return _blockApi.block(id: id).then((_) => true, onError: (_) => false);
  }
}
