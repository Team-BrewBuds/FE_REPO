import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/follow_list_repository.dart';
import 'package:brew_buds/domain/follow_list/follow_user_presenter.dart';

final class FollowerListPresenter extends Presenter {
  final FollowListRepository _followListRepository = FollowListRepository.instance;
  final String nickName;
  final List<FollowUserPresenter> _users = [];
  bool _hasNext = true;
  int _currentTab;
  int _pageNo = 1;

  bool get hasNext => _hasNext;

  List<FollowUserPresenter> get users => List.unmodifiable(_users);

  FollowerListPresenter({required this.nickName, int currentTab = 0}) : _currentTab = currentTab {
    moreData();
  }

  moreData({bool changedTab = false}) {
    if (changedTab) {
      _users.clear();
      _pageNo = 1;
      _hasNext = true;
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

  _fetchFollowings() async {
    if (!hasNext) return;
    final nextPage = await _followListRepository.fetchMyFollowerList(page: _pageNo, type: 'following');
    _users.addAll(nextPage.results.map((user) => FollowUserPresenter(user: user)));
    _hasNext = nextPage.hasNext;
    _pageNo++;
    notifyListeners();
  }

  _fetchFollowers() async {
    if (!hasNext) return;
    final nextPage = await _followListRepository.fetchMyFollowerList(page: _pageNo, type: 'follower');
    _users.addAll(nextPage.results.map((user) => FollowUserPresenter(user: user)));
    _hasNext = nextPage.hasNext;
    _pageNo++;
    notifyListeners();
  }
}
