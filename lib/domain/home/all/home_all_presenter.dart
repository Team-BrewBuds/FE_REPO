import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feed/feed.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final PostRepository postRepository = PostRepository.instance;
  final TastedRecordRepository tastedRecordRepository = TastedRecordRepository.instance;
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  int _currentTypeIndex = 0;

  @override
  Future<void> fetchMoreData() async {
    if (!hasNext) return;

    final newPage = await homeRepository.fetchFeedPage(
      feedType: _feedTypeList[_currentTypeIndex],
      pageNo: currentPage + 1,
    );

    defaultPage = defaultPage.copyWith(
      results: defaultPage.results + newPage.results,
      hasNext: newPage.hasNext,
    );

    notifyListeners();

    if (!newPage.hasNext && _currentTypeIndex < 3) {
      _currentTypeIndex += 1;
      currentPage = 0;
      defaultPage = defaultPage.copyWith(hasNext: true);
    } else {
      currentPage += 1;
    }

    if (defaultPage.results.length < 12 && _currentTypeIndex < 3) {
      fetchMoreData();
    }
  }

  @override
  Future<void> onRefresh() async {
    _currentTypeIndex = 0;
    super.onRefresh();
  }

  @override
  onTappedFollowAt(int index) {
    final feed = data[index];
    switch (feed) {
      case PostFeed():
        postRepository.follow(post: feed.data).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.post(
                  data: feed.data.copyWith(isAuthorFollowing: !feed.data.isAuthorFollowing),
                ),
              ),
            );
        break;
      case TastedRecordFeed():
        tastedRecordRepository.follow(id: feed.data.author.id, isFollow: feed.data.isAuthorFollowing).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.tastedRecord(
                  data: feed.data.copyWith(isAuthorFollowing: !feed.data.isAuthorFollowing),
                ),
              ),
            );
        break;
    }
  }

  @override
  onTappedLikeAt(int index) {
    final feed = data[index];
    switch (feed) {
      case PostFeed():
        postRepository.like(post: feed.data).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.post(
                  data: feed.data.isLiked
                      ? feed.data.copyWith(likeCount: feed.data.likeCount - 1, isLiked: false)
                      : feed.data.copyWith(likeCount: feed.data.likeCount + 1, isLiked: true),
                ),
              ),
            );
        break;
      case TastedRecordFeed():
        tastedRecordRepository.like(id: feed.data.id, isLiked: feed.data.isLiked).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.tastedRecord(
                  data: feed.data.isLiked
                      ? feed.data.copyWith(likeCount: feed.data.likeCount - 1, isLiked: false)
                      : feed.data.copyWith(likeCount: feed.data.likeCount + 1, isLiked: true),
                ),
              ),
            );
        break;
    }
  }

  @override
  onTappedSavedAt(int index) {
    final feed = data[index];
    switch (feed) {
      case PostFeed():
        postRepository.save(post: feed.data).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.post(
                  data: feed.data.copyWith(isSaved: !feed.data.isSaved),
                ),
              ),
            );
        break;
      case TastedRecordFeed():
        tastedRecordRepository.save(id: feed.data.author.id, isSaved: feed.data.isSaved).then(
              (_) => _updateFeedAt(
                index,
                newFeed: Feed.tastedRecord(
                  data: feed.data.copyWith(isSaved: !feed.data.isSaved),
                ),
              ),
            );
        break;
    }
  }

  _updateFeedAt(int index, {required Feed newFeed}) {
    final List<Feed> newData = List.from(defaultPage.results);
    newData[index] = newFeed;
    defaultPage = defaultPage.copyWith(results: newData);
    notifyListeners();
  }
}
