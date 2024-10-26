import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/feed.dart';
import 'package:brew_buds/model/feed_page.dart';

final class HomeAllPresenter extends HomeViewPresenter<Feed> {
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  final HomeRepository _repository;
  int _currentTypeIndex = 0;
  FeedPage _page = FeedPage.initial();

  HomeAllPresenter({
    required HomeRepository repository,
  }): _repository = repository;

  @override
  List<Feed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    final result = await _repository.fetchFeedPage(
      feedType: _feedTypeList[_currentTypeIndex],
      pageNo: _page.currentPage + 1,
    );
    if (result.hasNext == false) {
      _currentTypeIndex += 1;
      _page = _page.copyWith(
        feeds: _page.feeds + result.feeds,
        currentPage: 0,
        hasNext: true,
      );
    } else {
      _page = _page.copyWith(
        feeds: _page.feeds + result.feeds,
        currentPage: result.currentPage,
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
    _page = FeedPage.initial();
    while (feeds.isEmpty) {
      await fetchMoreData();
    }
  }
}
