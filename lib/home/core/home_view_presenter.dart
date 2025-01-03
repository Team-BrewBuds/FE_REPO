import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T extends Feed> extends ChangeNotifier {
  final HomeRepository repository;
  final List<RecommendedUserPage> _recommendedUserPages = [];

  HomeViewPresenter({required this.repository});

  List<T> get feeds;

  bool get hasNext;

  List<RecommendedUserPage> get recommendedUserPages => _recommendedUserPages;

  Future<void> initState() async {
    _recommendedUserPages.clear();
  }

  Future<void> onRefresh() async {
    _recommendedUserPages.clear();
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
      _recommendedUserPages.add(page);
      notifyListeners();
    }
  }

  onTappedLikeButton(T feed);

  onTappedSavedButton(T feed);

  onTappedFollowButton(T feed);

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
