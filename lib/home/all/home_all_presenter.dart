import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:brew_buds/model/pages//feed_page.dart';
import 'package:brew_buds/model/recommended_user.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  final HomeRepository _repository;
  int _currentTypeIndex = 0;
  int _currentPage = 0;
  FeedPage _page = FeedPage.initial();

  HomeAllPresenter({
    required HomeRepository repository,
  }) : _repository = repository;

  @override
  List<Feed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    final result = await _repository.fetchFeedPage(
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

  Future<void> onTappedLikeButton(Feed targetFeed) async {
    if (targetFeed is PostInFeed) {
      if (targetFeed.isLiked) {
        await _repository.unlike(type: 'post', id: targetFeed.id).then(
          (_) {
            _page = _page.copyWith(
              feeds: _page.feeds.map(
                (feed) {
                  if (feed.id == targetFeed.id) {
                    return targetFeed.copyWith(isLiked: false);
                  } else {
                    return feed;
                  }
                },
              ).toList(),
            );
            notifyListeners();
          },
        );
      } else {
        await _repository.like(type: 'post', id: targetFeed.id).then(
              (_) {
            _page = _page.copyWith(
              feeds: _page.feeds.map(
                    (feed) {
                  if (feed.id == targetFeed.id) {
                    return targetFeed.copyWith(isLiked: true);
                  } else {
                    return feed;
                  }
                },
              ).toList(),
            );
            notifyListeners();
          },
        );
      }
    } else if (targetFeed is TastingRecordInFeed) {
      if (targetFeed.isLiked) {
        await _repository.unlike(type: 'tasted_record', id: targetFeed.id).then(
              (_) {
            _page = _page.copyWith(
              feeds: _page.feeds.map(
                    (feed) {
                  if (feed.id == targetFeed.id) {
                    return targetFeed.copyWith(isLiked: false);
                  } else {
                    return feed;
                  }
                },
              ).toList(),
            );
            notifyListeners();
          },
        );
      } else {
        await _repository.like(type: 'tasted_record', id: targetFeed.id).then(
              (_) {
            _page = _page.copyWith(
              feeds: _page.feeds.map(
                    (feed) {
                  if (feed.id == targetFeed.id) {
                    return targetFeed.copyWith(isLiked: true);
                  } else {
                    return feed;
                  }
                },
              ).toList(),
            );
            notifyListeners();
          },
        );
      }
    }
  }
}
