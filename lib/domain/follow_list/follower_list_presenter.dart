import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/follow_list_repository.dart';
import 'package:brew_buds/domain/follow_list/model/follow_user.dart';
import 'package:brew_buds/model/common/default_page.dart';

final class FollowerListPresenter extends Presenter {
  final FollowListRepository _followListRepository = FollowListRepository.instance;
  final String nickName;

  DefaultPage<FollowUser> _page = DefaultPage.initState();
  int _currentTab = 0;
  int _pageNo = 1;

  bool get hasNext => _page.hasNext;

  DefaultPage<FollowUser> get page => _page;

  FollowerListPresenter({
    required this.nickName,
  });

  init(int index) {
    _currentTab = index;
    _pageNo = 1;
    _page = DefaultPage.initState();
    moreData();
  }

  moreData({bool changedTab = false}) {
    if (changedTab) {
      _pageNo = 1;
      _page = DefaultPage.initState();
      notifyListeners();
    }

    if (_currentTab == 0) {
      _fetchFollowers();
    } else {
      _fetchFollowings();
    }
  }

  onChangeTab(int index) {
    _currentTab = index;
    moreData(changedTab: true);
  }

  _fetchFollowings() {
    if (!hasNext) return;
    _followListRepository.fetchMyFollowerList(page: _pageNo, type: 'following').then((newPage) {
      _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext);
      _pageNo += 1;
      notifyListeners();
    });
  }

  _fetchFollowers() {
    if (!hasNext) return;
    _followListRepository.fetchMyFollowerList(page: _pageNo, type: 'follower').then((newPage) {
      _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext);
      _pageNo += 1;
      notifyListeners();
    });
  }

  onTappedFollowButton(FollowUser user) {
    _followListRepository.follow(id: user.id, isFollow: user.isFollowing).then(
      (_) {
        _page = _page.copyWith(
          results: _page.results
              .map(
                (e) => e.id == user.id ? user.copyWith(isFollowing: !user.isFollowing) : e,
              )
              .toList(),
        );
        notifyListeners();
      },
    );
  }
}
