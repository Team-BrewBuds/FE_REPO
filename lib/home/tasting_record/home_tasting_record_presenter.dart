import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:brew_buds/model/recommended_user.dart';

final class HomeTastingRecordPresenter extends HomeViewPresenter<TastingRecordInFeed> {
  TastingRecordFeedPage _page = TastingRecordFeedPage.initial();
  int _currentPage = 0;

  HomeTastingRecordPresenter({
    required super.repository,
  });

  @override
  List<TastingRecordInFeed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final result = await repository.fetchTastingRecordFeedPage(
        pageNo: _currentPage + 1,
      );
      _page = _page.copyWith(
        feeds: _page.feeds + result.feeds,
        hasNext: result.hasNext,
      );
      _currentPage += 1;
      notifyListeners();
    }
  }

  @override
  Future<void> initState() async {
    fetchMoreData();
  }

  @override
  Future<void> onRefresh() async {
    _page = TastingRecordFeedPage.initial();
    _currentPage = 0;
    notifyListeners();
    fetchMoreData();
  }

  @override
  onTappedLikeButton(TastingRecordInFeed feed) {
    like(type: 'tasted_record', id: feed.id, isLiked: feed.isLiked).then((_) {
      _updateFeed(
          newFeed: feed.copyWith(
        isLiked: !feed.isLiked,
        likeCount: feed.isLiked ? feed.likeCount - 1 : feed.likeCount + 1,
      ));
    });
  }

  @override
  onTappedSavedButton(TastingRecordInFeed feed) {
    save(type: 'tasted_record', id: feed.id, isSaved: feed.isSaved).then((_) {
      _updateFeed(newFeed: feed.copyWith(isSaved: !feed.isSaved));
    });
  }

  @override
  onTappedFollowButton(TastingRecordInFeed feed) {
    follow(id: feed.id, isFollowed: feed.isUserFollowing).then((_) {
      _updateFeed(newFeed: feed.copyWith(isUserFollowing: !feed.isUserFollowing));
    });
  }

  @override
  onTappedRecommendedUserFollowButton(RecommendedUser user, int pageIndex) {
    follow(id: user.user.id, isFollowed: user.isFollow).then(
          (_) => _updateRecommendedPage(user: user, pageIndex: pageIndex),
    );
  }

  _updateRecommendedPage({required RecommendedUser user, required int pageIndex}) {
    recommendedUserPages[pageIndex] = recommendedUserPages[pageIndex].copyWith(
        users: recommendedUserPages[pageIndex].users.map((e) {
          if (e.user.id == user.user.id) {
            return user.copyWith(isFollow: !user.isFollow);
          } else {
            return e;
          }
        }).toList());
    notifyListeners();
  }

  _updateFeed({required TastingRecordInFeed newFeed}) {
    _page = _page.copyWith(
      feeds: _page.feeds.map(
        (feed) {
          if (feed.id == newFeed.id) {
            return newFeed;
          } else {
            return feed;
          }
        },
      ).toList(),
    );
    notifyListeners();
  }
}
