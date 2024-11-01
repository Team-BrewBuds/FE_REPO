import 'package:brew_buds/data/home/home_repository.dart';
import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';

final class HomePostPresenter extends HomeViewPresenter<PostInFeed> {
  final List<String> _postSubjectFilterList = ['전체', '일반', '카페', '원두', '정보', '질문', '고민'];
  final HomeRepository _repository;
  PostFeedPage _page = PostFeedPage.initial();
  int _currentPage = 0;
  int _currentFilterIndex = 0;

  HomePostPresenter({
    required HomeRepository repository,
  }) : _repository = repository;

  List<String> get postSubjectFilterList => _postSubjectFilterList;

  int get currentFilterIndex => _currentFilterIndex;

  String get currentSubjectFilter => _postSubjectFilterList[_currentFilterIndex];

  @override
  List<PostInFeed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final result = await _repository.fetchPostFeedPage(
        subjectFilter: currentSubjectFilter,
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
    _page = PostFeedPage.initial();
    _currentPage = 0;
    notifyListeners();
    fetchMoreData();
  }

  onChangeSubject(int index) {
    if (_currentFilterIndex != index) {
      _page = PostFeedPage.initial();
      _currentPage = 0;
      _currentFilterIndex = index;
      notifyListeners();
      fetchMoreData();
    } else {
      onRefresh();
    }
  }
}
