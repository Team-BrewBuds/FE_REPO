import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/pages/recommended_users.dart';
import 'package:brew_buds/model/recommended_user.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T extends Feed> extends ChangeNotifier {
  final HomeRepository repository;
  DefaultPage<RecommendedUsers> _recommendedUserPage = DefaultPage.empty();

  DefaultPage<RecommendedUsers> get recommendedUserPage => _recommendedUserPage;

  HomeViewPresenter({
    required this.repository,
  });

  bool get hasNext;

  initState() {
    _recommendedUserPage = DefaultPage.empty();
    notifyListeners();
    fetchMoreRecommendedUsers();
  }

  Future<void> onRefresh() async {
    _recommendedUserPage = DefaultPage.empty();
    notifyListeners();
    fetchMoreRecommendedUsers();
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

  fetchMoreRecommendedUsers() async {
    final newPage = await repository.fetchRecommendedUserPage();

    _recommendedUserPage = _recommendedUserPage.copyWith(result: _recommendedUserPage.result + newPage.result);
    notifyListeners();
  }

  onTappedLikeButton(T feed);

  onTappedSavedButton(T feed);

  onTappedFollowButton(T feed);

  onTappedRecommendedUserFollowButton(RecommendedUser user, int pageIndex) {
    follow(id: user.user.id, isFollowed: user.isFollow).then((_) {
      final newUsers = _recommendedUserPage.result[pageIndex].users
          .map((e) => e.user.id == user.user.id ? user.copyWith(isFollow: !user.isFollow) : e).toList();
      _recommendedUserPage.copyWith(result: _recommendedUserPage.result.indexed.map((indexed) {
        if (indexed.$1 == pageIndex) {
          return indexed.$2.copyWith(users: newUsers);
        } else {
          return indexed.$2;
        }
      }).toList());
      notifyListeners();
    });
  }

  Future<void> like({required String type, required int id, required bool isLiked}) {
    if (isLiked) {
      return repository.unlike(type: type, id: id);
    } else {
      return repository.like(type: type, id: id);
    }
  }

  Future<void> save({required String type, required int id, required bool isSaved}) {
    if (isSaved) {
      return repository.delete(type: type, id: id);
    } else {
      return repository.save(type: type, id: id);
    }
  }

  Future<void> follow({required int id, required bool isFollowed}) {
    if (isFollowed) {
      return repository.unFollow(id: id);
    } else {
      return repository.follow(id: id);
    }
  }
}
