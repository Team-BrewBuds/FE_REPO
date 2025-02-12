import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:brew_buds/model/recommended_user.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T extends Feed> extends ChangeNotifier {
  final HomeRepository repository;
  List<RecommendedUserPage> recommendedUserPages = [];

  HomeViewPresenter({required this.repository});

  List<T> get feeds;

  bool get hasNext;

  Future<void> initState() async {
    recommendedUserPages.clear();
  }

  Future<void> onRefresh() async {
    recommendedUserPages.clear();
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
    final RecommendedUserPage? page = await repository.fetchRecommendedUserPage().then(
          (value) => value,
          onError: (_, __) => null,
        );
    if (page != null) {
      recommendedUserPages.add(page);
      notifyListeners();
    }
  }

  onTappedLikeButton(T feed);

  onTappedSavedButton(T feed);

  onTappedFollowButton(T feed);

  onTappedRecommendedUserFollowButton(RecommendedUser user, int pageIndex);

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
