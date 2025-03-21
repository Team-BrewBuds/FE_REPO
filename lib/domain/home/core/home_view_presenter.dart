import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:brew_buds/model/recommended/recommended_user.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T> extends ChangeNotifier {
  final HomeRepository homeRepository = HomeRepository.instance;
  List<RecommendedPage> _recommendedUserPage = [];
  int currentPage = 0;
  DefaultPage<T> defaultPage = DefaultPage.initState();

  HomeViewPresenter();

  bool get hasNext => defaultPage.hasNext;

  List<T> get data => defaultPage.results;

  initState() async {
    _recommendedUserPage = List.empty();
    defaultPage = DefaultPage.initState();
    currentPage = 0;
    notifyListeners();
    await fetchMoreRecommendedUsers();
    await fetchMoreData();
  }

  Future<void> onRefresh() async {
    _recommendedUserPage = List.empty();
    defaultPage = DefaultPage.initState();
    currentPage = 0;
    notifyListeners();
    await fetchMoreRecommendedUsers();
    await fetchMoreData();
  }

  Future<void> fetchMoreData();

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  Future<void> fetchMoreRecommendedUsers() async {
    final newPage = await homeRepository.fetchRecommendedUserPage();
    _recommendedUserPage = List.from(_recommendedUserPage)..add(newPage);
    notifyListeners();
  }

  onTappedLikeAt(int index);

  onTappedSavedAt(int index);

  onTappedFollowAt(int index);

  onTappedRecommendedUserFollowButton(RecommendedUser user, int pageIndex) {
    homeRepository.follow(id: user.id, isFollow: user.isFollow).then((_) {
      final previousPage = _recommendedUserPage[pageIndex];
      // final newPage = previousPage.copyWith(
      //   users: List.from(previousPage.users)..map((e) => e.id == user.id ? user.copyWith(isFollow: !user.isFollow) : e),
      // );
      _recommendedUserPage[pageIndex] = previousPage.copyWith(
        users: List.from(previousPage.users)..map((e) => e.id == user.id ? user.copyWith(isFollow: !user.isFollow) : e),
      );
      // _recommendedUserPage = List.from(_recommendedUserPage);
      notifyListeners();
    });
  }

  RecommendedPage? getRecommendedPage(int index) =>
      index >= _recommendedUserPage.length ? null : _recommendedUserPage[index];
}
