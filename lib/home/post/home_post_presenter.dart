import 'package:brew_buds/home/core/home_view_presenter.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/recommended_user.dart';

final class HomePostPresenter extends HomeViewPresenter<PostInFeed> {
  PostFeedPage _page = PostFeedPage.initial();
  int _currentPage = 0;
  int _currentFilterIndex = 0;

  HomePostPresenter({
    required super.repository,
  });

  List<String> get postSubjectFilterList => PostSubject.values.map((subject) => subject.toString()).toList();

  int get currentFilterIndex => _currentFilterIndex;

  PostSubject get currentSubjectFilter => PostSubject.values[_currentFilterIndex];

  @override
  List<PostInFeed> get feeds => _page.feeds;

  @override
  bool get hasNext => _page.hasNext;

  @override
  Future<void> fetchMoreData() async {
    if (_page.hasNext) {
      final result = await repository.fetchPostFeedPage(
        subjectFilter: currentSubjectFilter.toJsonValue(),
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

  @override
  onTappedLikeButton(PostInFeed feed) {
    like(type: 'post', id: feed.id, isLiked: feed.isLiked).then((_) {
      _updateFeed(
          newFeed: feed.copyWith(
        isLiked: !feed.isLiked,
        likeCount: feed.isLiked ? feed.likeCount - 1 : feed.likeCount + 1,
      ));
    });
  }

  @override
  onTappedSavedButton(PostInFeed feed) {
    save(type: 'post', id: feed.id, isSaved: feed.isSaved).then((_) {
      _updateFeed(newFeed: feed.copyWith(isSaved: !feed.isSaved));
    });
  }

  @override
  onTappedFollowButton(PostInFeed feed) {
    follow(id: feed.id, isFollowed: feed.isUserFollowing).then((_) {
      _updateFeed(newFeed: feed.copyWith(isUserFollowing: !feed.isUserFollowing));
    });
  }

  @override
  onTappedRecommendedUserFollowButton(RecommendedUser user, int pageIndex) {
    follow(id: user.user.id, isFollowed: user.isFollow).then(
          (_) => _updateRecommendedPage(user: user, pageIndex: pageIndex),
    );
  }

  _updateRecommendedPage({required RecommendedUser user, required int pageIndex}) {
    recommendedUserPages[pageIndex] = recommendedUserPages[pageIndex].copyWith(
        users: recommendedUserPages[pageIndex].users.map((e) {
          if (e.user.id == user.user.id) {
            return user.copyWith(isFollow: !user.isFollow);
          } else {
            return e;
          }
        }).toList());
    notifyListeners();
  }

  _updateFeed({required PostInFeed newFeed}) {
    _page = _page.copyWith(
      feeds: _page.feeds.map(
        (feed) {
          if (feed.id == newFeed.id) {
            return newFeed;
          } else {
            return feed;
          }
        },
      ).toList(),
    );
    notifyListeners();
  }
}
