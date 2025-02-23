import 'package:brew_buds/data/repository/popular_posts_repository.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:flutter/foundation.dart';

typedef PopularPostSubjectFilterState = ({List<String> postSubjectFilterList, int currentIndex});

final class PopularPostsPresenter extends ChangeNotifier {
  final List<PostSubject> _postSubjectFilterList = [
    PostSubject.all,
    PostSubject.normal,
    PostSubject.caffe,
    PostSubject.beans,
    PostSubject.information,
    PostSubject.question,
    PostSubject.worry,
  ];
  final PopularPostsRepository _repository;
  DefaultPage<PostInFeed> _page = DefaultPage.empty();
  int _currentPage = 0;
  int _currentFilterIndex = 0;

  PopularPostsPresenter({
    required PopularPostsRepository repository,
  }) : _repository = repository;

  PopularPostSubjectFilterState get subjectFilterState => (
        postSubjectFilterList: _postSubjectFilterList.map((subject) => subject.toString()).toList(),
        currentIndex: _currentFilterIndex,
      );

  DefaultPage<PostInFeed> get page => _page;

  List<String> get postSubjectFilterList => _postSubjectFilterList.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  List<PostInFeed> get popularPosts => _page.result;

  bool get hasNext => _page.hasNext;

  String get currentSubjectFilter => _postSubjectFilterList[_currentFilterIndex].toString();

  Future<void> initState() async {
    fetchMoreData();
  }

  Future<void> onRefresh() async {
    _page = DefaultPage.empty();
    _currentPage = 0;
    notifyListeners();
    fetchMoreData();
  }

  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final nextPage = await _repository.fetchPopularPostsPage(
        subject: _postSubjectFilterList[_currentFilterIndex].toJsonValue() ?? '',
        pageNo: _currentPage + 1,
      );
      _page = _page.copyWith(
        result: _page.result + nextPage.result,
        hasNext: nextPage.hasNext,
      );
      _currentPage += 1;
      notifyListeners();
    }
  }

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

  onChangeSubject(int index) {
    if (_currentFilterIndex != index) {
      _page = DefaultPage.empty();
      _currentPage = 0;
      _currentFilterIndex = index;
      notifyListeners();
      fetchMoreData();
    } else {
      onRefresh();
    }
  }
}
