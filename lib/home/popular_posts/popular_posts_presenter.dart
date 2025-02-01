import 'package:brew_buds/data/repository/popular_posts_repository.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:flutter/foundation.dart';

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
  PopularPostsPage _page = PopularPostsPage.initial();
  int _currentPage = 0;
  int _currentFilterIndex = 0;

  PopularPostsPresenter({
    required PopularPostsRepository repository,
  }) : _repository = repository;

  List<PostInFeed> get popularPosts => _page.popularPosts;

  bool get hasNext => _page.hasNext;

  List<String> get postSubjectFilterList => _postSubjectFilterList.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  String get currentSubjectFilter => _postSubjectFilterList[_currentFilterIndex].toString();

  Future<void> initState() async {
    fetchMoreData();
  }

  Future<void> onRefresh() async {
    _page = PopularPostsPage.initial();
    _currentPage = 0;
    notifyListeners();
    fetchMoreData();
  }

  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final result = await _repository.fetchPopularPostsPage(
        subject: _postSubjectFilterList[_currentFilterIndex].toJsonValue() ?? '',
        pageNo: _currentPage + 1,
      );
      _page = _page.copyWith(
        popularPosts: _page.popularPosts + result.popularPosts,
        hasNext: result.hasNext,
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
      _page = PopularPostsPage.initial();
      _currentPage = 0;
      _currentFilterIndex = index;
      notifyListeners();
      fetchMoreData();
    } else {
      onRefresh();
    }
  }
}
