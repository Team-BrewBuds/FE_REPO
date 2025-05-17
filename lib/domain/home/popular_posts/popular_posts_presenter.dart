import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/popular_posts_repository.dart';
import 'package:brew_buds/domain/home/popular_posts/popular_post_presenter.dart';
import 'package:brew_buds/model/post/post_subject.dart';

typedef PopularPostSubjectFilterState = ({List<String> postSubjectFilterList, int currentIndex});

final class PopularPostsPresenter extends Presenter {
  final PopularPostsRepository _repository = PopularPostsRepository.instance;
  bool _isLoading = false;
  List<PopularPostPresenter> _presenters = [];
  bool _hasNext = true;
  int _currentPage = 1;
  int _currentFilterIndex = 0;

  PopularPostSubjectFilterState get subjectFilterState => (
        postSubjectFilterList: PostSubject.values.map((subject) => subject.toString()).toList(),
        currentIndex: _currentFilterIndex,
      );

  bool get isLoading => _isLoading;

  List<PopularPostPresenter> get presenters => List.unmodifiable(_presenters);

  List<String> get postSubjectFilterList => PostSubject.values.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  bool get hasNext => _hasNext;

  String get currentSubjectFilter => PostSubject.values[_currentFilterIndex].toString();

  Future<void> initState() async {
    fetchMoreData();
  }

  Future<void> onRefresh() async {
    fetchMoreData(isPageChanged: true, isRefresh: true);
  }

  Future<void> fetchMoreData({bool isPageChanged = false, bool isRefresh = false}) async {
    if (isPageChanged) {
      _presenters = List.empty(growable: true);
      _currentPage = 1;
      _hasNext = true;
      _isLoading = false;
      if (!isRefresh) {
        notifyListeners();
      }
    }

    if (_isLoading) return;

    _isLoading = true;
    if (!isRefresh) {
      notifyListeners();
    }

    if (_hasNext) {
      final nextPage = await _repository.fetchPopularPostsPage(
        subject: PostSubject.values[_currentFilterIndex].toJsonValue() ?? '',
        pageNo: _currentPage,
      );

      _presenters.addAll(nextPage.results.map((e) => PopularPostPresenter(post: e)));
      _hasNext = nextPage.hasNext;
      _currentPage += 1;
    }

    _isLoading = false;
    notifyListeners();
  }

  onChangeSubject(int index) {
    if (_currentFilterIndex != index) {
      _currentFilterIndex = index;
      fetchMoreData(isPageChanged: true);
    } else {
      onRefresh();
    }
  }
}
