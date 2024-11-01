import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';

final class HomeTastingRecordPresenter extends HomeViewPresenter<TastingRecordInFeed> {
  final HomeRepository _repository;
  TastingRecordFeedPage _page = TastingRecordFeedPage.initial();
  int _currentPage = 0;

  HomeTastingRecordPresenter({
    required HomeRepository repository,
  }) : _repository = repository;

  @override
  List<TastingRecordInFeed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final result = await _repository.fetchTastingRecordFeedPage(
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
}
