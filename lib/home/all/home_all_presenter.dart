import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:brew_buds/model/pages//feed_page.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:brew_buds/model/recommended_user.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  int _currentTypeIndex = 0;
  int _currentPage = 0;
  FeedPage _page = FeedPage.initial();

  HomeAllPresenter({
    required super.repository,
  });

  @override
  List<Feed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    final result = await repository.fetchFeedPage(
      feedType: _feedTypeList[_currentTypeIndex],
      pageNo: _currentPage + 1,
    );
    if (result.hasNext == false) {
      _currentTypeIndex += 1;
      _currentPage = 0;
      _page = _page.copyWith(
        feeds: _page.feeds + result.feeds,
        hasNext: true,
      );
    } else {
      _currentPage += 1;
      _page = _page.copyWith(
        feeds: _page.feeds + result.feeds,
        hasNext: result.hasNext,
      );
    }
    notifyListeners();
  }

  @override
  Future<void> initState() async {
    while (feeds.isEmpty) {
      await fetchMoreData();
    }
  }

  @override
  Future<void> onRefresh() async {
    _currentTypeIndex = 0;
    _currentPage = 0;
    _page = FeedPage.initial();
    notifyListeners();
    while (feeds.isEmpty) {
      await fetchMoreData();
    }
  }

  @override
  onTappedLikeButton(Feed feed) {
    if (feed is PostInFeed) {
      like(type: 'post', id: feed.id, isLiked: feed.isLiked).then((_) {
        _updateFeed(
            newFeed: feed.copyWith(
          isLiked: !feed.isLiked,
          likeCount: feed.isLiked ? feed.likeCount - 1 : feed.likeCount + 1,
        ));
      });
    } else if (feed is TastingRecordInFeed) {
      like(type: 'tasted_record', id: feed.id, isLiked: feed.isLiked).then((_) {
        _updateFeed(
            newFeed: feed.copyWith(
          isLiked: !feed.isLiked,
          likeCount: feed.isLiked ? feed.likeCount - 1 : feed.likeCount + 1,
        ));
      });
    }
  }

  @override
  onTappedSavedButton(Feed feed) {
    if (feed is PostInFeed) {
      save(type: 'post', id: feed.id, isSaved: feed.isSaved).then((_) {
        _updateFeed(newFeed: feed.copyWith(isSaved: !feed.isSaved));
      });
    } else if (feed is TastingRecordInFeed) {
      save(type: 'tasted_record', id: feed.id, isSaved: feed.isSaved).then((_) {
        _updateFeed(newFeed: feed.copyWith(isSaved: !feed.isSaved));
      });
    }
  }

  @override
  onTappedFollowButton(Feed feed) {
    if (feed is PostInFeed) {
      follow(id: feed.author.id, isFollowed: feed.isUserFollowing).then((_) {
        _updateFeed(newFeed: feed.copyWith(isUserFollowing: !feed.isUserFollowing));
      });
    } else if (feed is TastingRecordInFeed) {
      follow(id: feed.author.id, isFollowed: feed.isUserFollowing).then((_) {
        _updateFeed(newFeed: feed.copyWith(isUserFollowing: !feed.isUserFollowing));
      });
    }
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

  _updateFeed({required Feed newFeed}) {
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
