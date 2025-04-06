import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:brew_buds/model/recommended/recommended_user.dart';
import 'package:flutter/foundation.dart';

typedef FeedState = ({bool isLoading, List<Feed> feeds});

final class HomePresenter extends Presenter {
  final HomeRepository homeRepository = HomeRepository.instance;
  final PostRepository postRepository = PostRepository.instance;
  final TastedRecordRepository tastedRecordRepository = TastedRecordRepository.instance;
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  final bool _isGuest;
  bool _isLoadingAction = false;
  bool _isLoading = false;
  int _currentTypeIndex = 0;
  PostSubject _currentSubject = PostSubject.all;
  List<RecommendedPage> _recommendedUserPage = [];
  int _currentTab = 0;
  int _pageNo = 1;
  DefaultPage<Feed> _feedPage = DefaultPage.initState();

  bool get isGuest => _isGuest;

  bool get isLoadingAction => _isLoadingAction;

  bool get isLoading => _isLoading;

  List<Feed> get feeds => _feedPage.results;

  FeedState get feedState => (isLoading: _isLoading, feeds: _feedPage.results);

  int get itemCount => _feedPage.results.length;

  List<RecommendedPage> get recommendedUserPage => _recommendedUserPage;

  PostSubject get currentSubject => _currentSubject;

  bool get isPostFeed => _currentTab == 2;

  HomePresenter({required bool isGuest}) : _isGuest = isGuest {
    initState();
  }

  initState() {
    fetchMoreData();
  }

  onRefresh() {
    fetchMoreData(isPageChanged: true);
  }

  fetchMoreData({bool isPageChanged = false}) async {
    if (isPageChanged) {
      _recommendedUserPage = List.empty(growable: true);
      _feedPage = DefaultPage.initState();
      _pageNo = 1;
      notifyListeners();
    }

    if (!_feedPage.hasNext) return;

    _isLoading = true;
    notifyListeners();

    await fetchFeeds();
    if (!_isGuest) {
      await fetchRecommendedUsers();
    }
    notifyListeners();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeeds() async {
    if (_currentTab == 0) {
      final nextPage = await homeRepository.fetchFeedPage(feedType: _feedTypeList[_currentTypeIndex], pageNo: _pageNo);

      _feedPage = await compute(
        (state) {
          return state.$1.copyWith(results: state.$1.results + state.$2.results);
        },
        (_feedPage, nextPage),
      );

      if (!nextPage.hasNext && _currentTypeIndex < 2 && (itemCount / 12).toInt() < _pageNo) {
        _currentTypeIndex++;
        _pageNo = 1;
        return await fetchFeeds();
      } else {
        _pageNo++;
      }
    } else if (_currentTab == 1) {
      final nextPage = await tastedRecordRepository.fetchTastedRecordFeedPage(pageNo: _pageNo);

      _feedPage = await compute(
        (state) {
          return state.$1.copyWith(results: state.$1.results + state.$2.results);
        },
        (_feedPage, nextPage),
      );
      _pageNo++;
    } else {
      final nextPage =
          await postRepository.fetchPostPage(subjectFilter: _currentSubject.toJsonValue(), pageNo: _pageNo);

      _feedPage = await compute(
        (state) {
          return state.$1.copyWith(results: state.$1.results + state.$2.results);
        },
        (_feedPage, nextPage),
      );
      _pageNo++;
    }
  }

  Future<void> fetchRecommendedUsers() async {
    final newPage = await homeRepository
        .fetchRecommendedUserPage()
        .then((page) => Future<RecommendedPage?>.value(page))
        .onError((_, __) => null);
    if (newPage != null) {
      _recommendedUserPage = await compute(
        (state) => List.from(state.$1)..add(state.$2),
        (_recommendedUserPage, newPage),
      );
    }
  }

  onChangeTab(int index) {
    if (index == 0 && _currentTab != index) {
      _currentTypeIndex = 0;
      _currentTab = index;
      fetchMoreData(isPageChanged: true);
    } else if (index == 2 && _currentTab != index) {
      _currentSubject = PostSubject.all;
      _currentTab = index;
      fetchMoreData(isPageChanged: true);
    } else if (index == 1 && _currentTab != index) {
      _currentTab = index;
      fetchMoreData(isPageChanged: true);
    } else {
      onRefresh();
    }
  }

  onSelectPostSubject(PostSubject subject) {
    _currentSubject = subject;
    notifyListeners();

    fetchMoreData(isPageChanged: true);
  }

  onTappedLikeAt(int index) async {
    _isLoadingAction = true;
    notifyListeners();

    final feed = _feedPage.results[index];
    switch (feed) {
      case PostFeed():
        final result = await homeRepository
            .like(type: 'post', id: feed.data.id, isLiked: feed.data.isLiked)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              previousFeeds[message.$2] = Feed.post(
                data: message.$3.data.copyWith(
                  isLiked: !message.$3.data.isLiked,
                  likeCount: message.$3.data.isLiked ? message.$3.data.likeCount - 1 : message.$3.data.likeCount + 1,
                ),
              );
              return previousFeeds;
            },
            (_feedPage.results, index, feed),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
      case TastedRecordFeed():
        final result = await homeRepository
            .like(type: 'tasted_record', id: feed.data.id, isLiked: feed.data.isLiked)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              previousFeeds[message.$2] = Feed.tastedRecord(
                data: message.$3.data.copyWith(
                  isLiked: !message.$3.data.isLiked,
                  likeCount: message.$3.data.isLiked ? message.$3.data.likeCount - 1 : message.$3.data.likeCount + 1,
                ),
              );
              return previousFeeds;
            },
            (_feedPage.results, index, feed),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
    }
    _isLoadingAction = false;
    notifyListeners();
  }

  onTappedSavedAt(int index) async {
    _isLoadingAction = true;
    notifyListeners();

    final feed = _feedPage.results[index];
    switch (feed) {
      case PostFeed():
        final result = await homeRepository
            .save(type: 'post', id: feed.data.id, isSaved: feed.data.isSaved)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              previousFeeds[message.$2] = Feed.post(data: message.$3.data.copyWith(isSaved: !message.$3.data.isSaved));
              return previousFeeds;
            },
            (_feedPage.results, index, feed),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
      case TastedRecordFeed():
        final result = await homeRepository
            .save(type: 'tasted_record', id: feed.data.id, isSaved: feed.data.isSaved)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              previousFeeds[message.$2] = Feed.tastedRecord(
                data: message.$3.data.copyWith(isSaved: !message.$3.data.isSaved),
              );
              return previousFeeds;
            },
            (_feedPage.results, index, feed),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
    }
    _isLoadingAction = false;
    notifyListeners();
  }

  onTappedFollowAt(int index) async {
    _isLoadingAction = true;
    notifyListeners();

    final feed = _feedPage.results[index];
    switch (feed) {
      case PostFeed():
        final result = await homeRepository
            .follow(id: feed.data.author.id, isFollow: feed.data.isAuthorFollowing)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              return previousFeeds.map(
                (feed) {
                  switch (feed) {
                    case PostFeed():
                      if (feed.data.author.id == message.$2) {
                        return Feed.post(data: feed.data.copyWith(isAuthorFollowing: !message.$3));
                      } else {
                        return feed;
                      }
                    case TastedRecordFeed():
                      if (feed.data.author.id == message.$2) {
                        return Feed.tastedRecord(data: feed.data.copyWith(isAuthorFollowing: !message.$3));
                      } else {
                        return feed;
                      }
                  }
                },
              ).toList();
            },
            (_feedPage.results, feed.data.author.id, feed.data.isAuthorFollowing),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
      case TastedRecordFeed():
        final result = await homeRepository
            .follow(id: feed.data.author.id, isFollow: feed.data.isAuthorFollowing)
            .then((_) => true)
            .onError((_, __) => false);
        if (result) {
          final newFeeds = await compute(
            (message) {
              final previousFeeds = List<Feed>.from(message.$1);
              return previousFeeds.map(
                (feed) {
                  switch (feed) {
                    case PostFeed():
                      if (feed.data.author.id == message.$2) {
                        return Feed.post(data: feed.data.copyWith(isAuthorFollowing: !message.$3));
                      } else {
                        return feed;
                      }
                    case TastedRecordFeed():
                      if (feed.data.author.id == message.$2) {
                        return Feed.tastedRecord(data: feed.data.copyWith(isAuthorFollowing: !message.$3));
                      } else {
                        return feed;
                      }
                  }
                },
              ).toList();
            },
            (_feedPage.results, feed.data.author.id, feed.data.isAuthorFollowing),
          );
          _feedPage = await compute(
            (message) => message.$1.copyWith(results: message.$2),
            (_feedPage, newFeeds),
          );
        }
    }
    _isLoadingAction = false;
    notifyListeners();
  }

  onTappedRecommendedUserFollowButton(RecommendedUser user, {required int pageNo}) async {
    final result =
        await homeRepository.follow(id: user.id, isFollow: user.isFollow).then((_) => true).onError((_, __) => false);

    if (result) {
      final newUser = await compute(
        (message) => message.copyWith(
          isFollow: !message.isFollow,
          followerCount: message.isFollow ? message.followerCount - 1 : message.followerCount + 1,
        ),
        user,
      );
      _recommendedUserPage[pageNo] = await compute(
        (message) => message.$1.copyWith(
          users: message.$1.users.map((user) => user.id == message.$2.id ? message.$2 : user).toList(),
        ),
        (_recommendedUserPage[pageNo], newUser),
      );
      notifyListeners();
    } else {
      return null;
    }
  }

  RecommendedPage? getRecommendedPage(int index) =>
      index >= _recommendedUserPage.length ? null : _recommendedUserPage[index];

  Feed getFeed(int index) => _feedPage.results[index];
}
