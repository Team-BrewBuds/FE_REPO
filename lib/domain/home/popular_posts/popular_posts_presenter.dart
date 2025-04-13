import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/popular_posts_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:flutter/foundation.dart';

typedef PopularPostSubjectFilterState = ({List<String> postSubjectFilterList, int currentIndex});

final class PopularPostsPresenter extends Presenter {
  final PopularPostsRepository _repository = PopularPostsRepository.instance;
  DefaultPage<Post> _page = DefaultPage.initState();
  int _currentPage = 0;
  int _currentFilterIndex = 0;

  PopularPostSubjectFilterState get subjectFilterState => (
        postSubjectFilterList: PostSubject.values.map((subject) => subject.toString()).toList(),
        currentIndex: _currentFilterIndex,
      );

  DefaultPage<Post> get page => _page;

  List<String> get postSubjectFilterList => PostSubject.values.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  List<Post> get popularPosts => _page.results;

  bool get hasNext => _page.hasNext;

  String get currentSubjectFilter => PostSubject.values[_currentFilterIndex].toString();

  Future<void> initState() async {
    _page = DefaultPage.initState();
    _currentPage = 0;
    notifyListeners();
    fetchMoreData();
  }

  Future<void> onRefresh() async {
    _page = DefaultPage.initState();
    _currentPage = 0;
    notifyListeners();
    await fetchMoreData();
  }

  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final nextPage = await _repository.fetchPopularPostsPage(
        subject: PostSubject.values[_currentFilterIndex].toJsonValue() ?? '',
        pageNo: _currentPage + 1,
      );

      _page = await compute((message) {
        return message.$2.copyWith(results: message.$1.results + message.$2.results);
      }, (_page, nextPage));

      _currentPage += 1;
      notifyListeners();
    }
  }

  onChangeSubject(int index) {
    if (_currentFilterIndex != index) {
      _page = DefaultPage.initState();
      _currentPage = 0;
      _currentFilterIndex = index;
      notifyListeners();
      fetchMoreData();
    } else {
      onRefresh();
    }
  }
}
