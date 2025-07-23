import 'dart:async';

import 'package:brew_buds/core/analytics_manager.dart';
import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/home_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/domain/home/model/feed_page.dart';
import 'package:brew_buds/domain/home/recommended_buddies/recommended_buddies_presenter.dart';
import 'package:brew_buds/model/common/default_page.dart';
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
  late final StreamSubscription _postSub;
  late final StreamSubscription _tastedRecordSub;
  FeedPage _feedPage = FeedPage.total();
  bool _isLoading = false;
  PostSubject _currentSubject = PostSubject.all;
  List<RecommendedBuddiesPresenter> _recommendedBuddiesPresenter = [];
  int _currentTab = 0;

  bool get hasNext => _feedPage.hasNext && _feedPage.feeds.isNotEmpty;

  bool get isGuest => AccountRepository.instance.isGuest;

  List<FeedPresenter> get feedPresenters => _feedPage.feeds;

  List<RecommendedBuddiesPresenter> get recommendedUserPage => List.unmodifiable(_recommendedBuddiesPresenter);

  PostSubject get currentSubject => _currentSubject;

  bool get isPostFeed => _currentTab == 2;

  HomePresenter() {
    AnalyticsManager.instance.logScreen(screenName: 'home_all');
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
    _feedPage.onRefresh();
    await fetchMoreData(isPageChanged: true, isRefresh: true);
  }

  _onPostEvent(PostEvent event) {
    switch (event) {
      case PostCreateEvent():
        onRefresh();
        break;
      default:
        break;
    }
  }

  _onTastedRecordEvent(TastedRecordEvent event) {
    switch (event) {
      case TastedRecordCreateEvent():
        onRefresh();
        break;
      default:
        break;
    }
  }

  login() {
    fetchMoreData(isPageChanged: true);
  }

  Future<void> fetchMoreData({bool isPageChanged = false, bool isRefresh = false}) async {
    if (isPageChanged) {
      _recommendedBuddiesPresenter = List.empty(growable: true);
      _isLoading = false;
      if (!isRefresh) {
        notifyListeners();
      }
    }

    if (_isLoading) return;

    if (!_feedPage.hasNext) return;

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
    final currentPage = _feedPage;
    final DefaultPage<Feed> nextPage;
    switch (currentPage) {
      case TotalFeedPage():
        if (currentPage.hasNextCommonFeeds) {
          nextPage = await homeRepository.fetchFeedPage(pageNo: _feedPage.currentPageNumber + 1);

          if (!nextPage.hasNext) {
            _feedPage.addItems(newItems: nextPage.results, hasNext: nextPage.hasNext);
            final nextRandomPage = await homeRepository.fetchFeedPage(feedType: 'refresh', pageNo: _feedPage.currentPageNumber + 1);
            _feedPage.addItems(newItems: nextRandomPage.results, hasNext: nextRandomPage.hasNext);
            return;
          }
         } else {
          nextPage = await homeRepository.fetchFeedPage(feedType: 'refresh', pageNo: _feedPage.currentPageNumber + 1);
         }
        break;
      case PostFeedPage():
        nextPage = await postRepository.fetchPostPage(
          subjectFilter: _currentSubject.toJsonValue(),
          pageNo: _feedPage.currentPageNumber + 1,
        );
        break;
      case TastedRecordFeedPage():
        nextPage = await tastedRecordRepository.fetchTastedRecordFeedPage(pageNo: _feedPage.currentPageNumber + 1);
        break;
    }

    _feedPage.addItems(newItems: nextPage.results, hasNext: nextPage.hasNext);
  }

  Future<void> fetchRecommendedUsers() async {
    if (isGuest) return;

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
      AnalyticsManager.instance.logScreen(screenName: 'home_all');
      _currentTab = index;
      _feedPage = FeedPage.total();
      fetchMoreData(isPageChanged: true);
    } else if (index == 2 && _currentTab != index) {
      AnalyticsManager.instance.logScreen(screenName: 'home_tasted_record');
      _currentSubject = PostSubject.all;
      _currentTab = index;
      _feedPage = FeedPage.post();
      fetchMoreData(isPageChanged: true);
    } else if (index == 1 && _currentTab != index) {
      AnalyticsManager.instance.logScreen(screenName: 'home_post');
      _currentTab = index;
      _feedPage = FeedPage.tastedRecord();
      fetchMoreData(isPageChanged: true);
    } else {
      onRefresh();
    }
  }

  onSelectPostSubject(PostSubject subject) {
    _currentSubject = subject;
    notifyListeners();

    _feedPage.onRefresh();
    fetchMoreData(isPageChanged: true);
  }

  RecommendedBuddiesPresenter? getRecommendedBuddiesPresenter(int index) =>
      _recommendedBuddiesPresenter.elementAtOrNull(index);
}
