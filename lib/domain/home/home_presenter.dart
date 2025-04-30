import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/post_feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/tasted_record_feed_presenter.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddies_presenter.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/events/tasted_record_event.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';

typedef FeedState = ({bool isLoading, List<Feed> feeds});

final class HomePresenter extends Presenter {
  final HomeRepository homeRepository = HomeRepository.instance;
  final PostRepository postRepository = PostRepository.instance;
  final TastedRecordRepository tastedRecordRepository = TastedRecordRepository.instance;
  final List<FeedType> _feedTypeList = [FeedType.following, FeedType.common, FeedType.random];
  late final StreamSubscription _postSub;
  late final StreamSubscription _tastedRecordSub;
  bool _isGuest;
  bool _isLoading = false;
  int _currentTypeIndex = 0;
  PostSubject _currentSubject = PostSubject.all;
  List<RecommendedBuddiesPresenter> _recommendedBuddiesPresenter = [];
  int _currentTab = 0;
  int _pageNo = 1;
  bool _hasNext = true;
  List<FeedPresenter> _feedPresenters = [];

  bool get hasNext => _hasNext && _feedPresenters.isNotEmpty;

  bool get isGuest => _isGuest;

  List<FeedPresenter> get feedPresenters => List.unmodifiable(_feedPresenters);

  List<RecommendedBuddiesPresenter> get recommendedUserPage => List.unmodifiable(_recommendedBuddiesPresenter);

  PostSubject get currentSubject => _currentSubject;

  bool get isPostFeed => _currentTab == 2;

  HomePresenter({required bool isGuest}) : _isGuest = isGuest {
    _postSub = EventBus.instance.on<PostEvent>().listen(_onPostEvent);
    _tastedRecordSub = EventBus.instance.on<TastedRecordEvent>().listen(_onTastedRecordEvent);
    initState();
  }

  initState() {
    fetchMoreData(isPageChanged: true);
  }

  @override
  dispose() {
    _postSub.cancel();
    _tastedRecordSub.cancel();
    super.dispose();
  }

  Future<void> onRefresh() async {
    await fetchMoreData(isPageChanged: true, isRefresh: true);
  }

  _onPostEvent(PostEvent event) {
    switch (event) {
      case PostDeleteEvent():
        _feedPresenters.removeWhere((presenter) {
          if (presenter is PostFeedPresenter) {
            return presenter.feed.data.id == event.id;
          } else {
            return false;
          }
        });
        notifyListeners();
        break;
      default:
        break;
    }
  }

  _onTastedRecordEvent(TastedRecordEvent event) {
    switch (event) {
      case TastedRecordDeleteEvent():
        _feedPresenters.removeWhere((presenter) {
          if (presenter is TastedRecordFeedPresenter) {
            return presenter.feed.data.id == event.id;
          } else {
            return false;
          }
        });
        notifyListeners();
        break;
      default:
        break;
    }
  }

  login() {
    _isGuest = false;
    onRefresh();
  }

  Future<void> fetchMoreData({bool isPageChanged = false, bool isRefresh = false}) async {
    if (isPageChanged) {
      _recommendedBuddiesPresenter = List.empty(growable: true);
      _feedPresenters = List.empty(growable: true);
      _currentTypeIndex = 0;
      _pageNo = 1;
      _hasNext = true;
      _isLoading = false;
      if (!isRefresh) {
        notifyListeners();
      }
    }

    if (_isLoading) return;

    if (!_hasNext) {
      if (_currentTab != 0 || (_currentTab == 0 && _currentTypeIndex == 2)) return;
    }

    _isLoading = true;
    if (!isRefresh) {
      notifyListeners();
    }

    await Future.wait([
      fetchFeeds(),
      fetchRecommendedUsers(),
    ]);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeeds() async {
    if (_currentTab == 0) {
      final nextPage = await homeRepository.fetchFeedPage(feedType: _feedTypeList[_currentTypeIndex], pageNo: _pageNo);

      _addAllFeeds(nextPage.results);
      _hasNext = nextPage.hasNext;

      if (!_hasNext && _currentTypeIndex < 2 && (feedPresenters.length / 12).toInt() < _pageNo) {
        _currentTypeIndex++;
        _pageNo = 1;
        return await fetchFeeds();
      } else {
        _pageNo++;
      }
    } else if (_currentTab == 1) {
      final nextPage = await tastedRecordRepository.fetchTastedRecordFeedPage(pageNo: _pageNo);
      _addAllFeeds(nextPage.results);
      _hasNext = nextPage.hasNext;
      _pageNo++;
    } else {
      final nextPage = await postRepository.fetchPostPage(
        subjectFilter: _currentSubject.toJsonValue(),
        pageNo: _pageNo,
      );

      _addAllFeeds(nextPage.results);
      _hasNext = nextPage.hasNext;
      _pageNo++;
    }
  }

  void _addAllFeeds(List<Feed> feeds) {
    _feedPresenters.addAll(
      feeds.map(
        (e) {
          switch (e) {
            case PostFeed():
              return PostFeedPresenter(feed: e);
            case TastedRecordFeed():
              return TastedRecordFeedPresenter(feed: e);
          }
        },
      ),
    );
  }

  Future<void> fetchRecommendedUsers() async {
    if (_isGuest) return;

    final newPage = await homeRepository
        .fetchRecommendedUserPage()
        .then((page) => Future<RecommendedPage?>.value(page))
        .onError((_, __) => null);
    if (newPage != null) {
      _recommendedBuddiesPresenter.add(RecommendedBuddiesPresenter(page: newPage));
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

  RecommendedBuddiesPresenter? getRecommendedBuddiesPresenter(int index) =>
      _recommendedBuddiesPresenter.elementAtOrNull(index);
}
