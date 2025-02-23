import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:brew_buds/model/recommended_user.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  int _currentTypeIndex = 0;
  int _currentPage = 0;
  DefaultPage<Feed> _page = DefaultPage.empty();

  HomeAllPresenter({
    required super.repository,
  });

  DefaultPage<Feed> get page => _page;

  @override
  bool get hasNext => _page.hasNext || _currentTypeIndex < 3;

  @override
  Future<void> fetchMoreData() async {
    if (!hasNext) return;

    final newPage = await repository.fetchFeedPage(
      feedType: _feedTypeList[_currentTypeIndex],
      pageNo: _currentPage + 1,
    );

    _page = _page.copyWith(
      result: _page.result + newPage.result,
      hasNext: newPage.hasNext,
    );

    notifyListeners();

    if (!newPage.hasNext && _currentTypeIndex < 3) {
      _currentTypeIndex += 1;
      _currentPage = 0;
    } else {
      _currentPage += 1;
    }

    if(_page.result.length < 12 && _currentTypeIndex < 3) {
      fetchMoreData();
    }
  }

  @override
  initState() async {
    super.initState();
    await fetchMoreData();
  }

  @override
  Future<void> onRefresh() async {
    super.onRefresh();
    _currentTypeIndex = 0;
    _currentPage = 0;
    _page = DefaultPage.empty();
    notifyListeners();

    await fetchMoreData();
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

  _updateFeed({required Feed newFeed}) {
    _page = _page.copyWith(
      result: _page.result.map(
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
