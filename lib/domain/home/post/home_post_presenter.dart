import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/domain/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';

typedef HomePostFeedFilterState = ({List<String> postSubjectFilterList, int currentFilterIndex});

final class HomePostPresenter extends HomeViewPresenter<Post> {
  final PostRepository _postRepository = PostRepository();
  int _currentFilterIndex = 0;

  HomePostPresenter();

  HomePostFeedFilterState get homePostFeedFilterState => (
        postSubjectFilterList: postSubjectFilterList,
        currentFilterIndex: currentFilterIndex,
      );

  List<String> get postSubjectFilterList => PostSubject.values.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  PostSubject get currentSubjectFilter => PostSubject.values[_currentFilterIndex];

  @override
  Future<void> fetchMoreData() async {
    if (hasNext) {
      final newPage = await _postRepository.fetchPostPage(
        subjectFilter: currentSubjectFilter.toJsonValue(),
        pageNo: currentPage + 1,
      );
      defaultPage = defaultPage.copyWith(
        results: defaultPage.results + newPage.results,
        hasNext: newPage.hasNext,
      );
      currentPage += 1;
      notifyListeners();
    }
  }

  onChangeSubject(int index) {
    if (_currentFilterIndex != index) {
      defaultPage = DefaultPage.initState();
      currentPage = 0;
      _currentFilterIndex = index;
      notifyListeners();
      fetchMoreData();
    } else {
      onRefresh();
    }
  }

  @override
  onTappedLikeAt(int index) {
    final post = data[index];
    _postRepository.like(post: post).then(
          (_) => _updateFeed(
            newPost: post.isLiked
                ? post.copyWith(isLiked: !post.isLiked, likeCount: post.likeCount - 1)
                : post.copyWith(isLiked: !post.isLiked, likeCount: post.likeCount + 1),
          ),
        );
  }

  @override
  onTappedSavedAt(int index) {
    final post = data[index];
    _postRepository.save(post: post).then((_) => _updateFeed(newPost: post.copyWith(isSaved: !post.isSaved)));
  }

  @override
  onTappedFollowAt(int index) {
    final post = data[index];
    _postRepository
        .follow(post: post)
        .then((_) => _updateFeed(newPost: post.copyWith(isAuthorFollowing: !post.isAuthorFollowing)));
  }

  _updateFeed({required Post newPost}) {
    defaultPage = defaultPage.copyWith(
      results: defaultPage.results.map(
        (post) {
          if (post.id == newPost.id) {
            return newPost;
          } else {
            return post;
          }
        },
      ).toList(),
    );
    notifyListeners();
  }
}
