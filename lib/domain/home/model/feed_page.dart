import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/post_feed_presenter.dart';
import 'package:brew_buds/domain/home/feed/presenter/tasted_record_feed_presenter.dart';
import 'package:brew_buds/model/feed/feed.dart';

// final class FeedPage {
//   final List<FeedPresenter<Feed>> _items = List.empty(growable: true);
//   bool _hasNext = true;
//
//   List<FeedPresenter<Feed>> get items => List.unmodifiable(_items);
//
//   int get currentPageNumber => (items.length / 12).toInt();
//
//   bool get hasNext => _hasNext;
//
//   addItems({required List<Feed> newItems, required bool hasNext}) {
//     _items.addAll(
//       newItems.map(
//         (e) {
//           switch (e) {
//             case PostFeed():
//               return PostFeedPresenter(feed: e);
//             case TastedRecordFeed():
//               return TastedRecordFeedPresenter(feed: e);
//           }
//         },
//       ),
//     );
//     _hasNext = hasNext;
//   }
// }

sealed class FeedPage {
  List<FeedPresenter<Feed>> get feeds;

  int get currentPageNumber;

  bool get hasNext;

  addItems({required List<Feed> newItems, required bool hasNext});

  onRefresh();

  factory FeedPage.total() => TotalFeedPage();

  factory FeedPage.post() => PostFeedPage();

  factory FeedPage.tastedRecord() => TastedRecordFeedPage();
}

final class TotalFeedPage implements FeedPage {
  final List<FeedPresenter<Feed>> _commonFeeds = List.empty(growable: true);
  final List<FeedPresenter<Feed>> _randomFeeds = List.empty(growable: true);
  bool _commonFeedsHasNext = true;
  bool _randomFeedsHasNext = true;

  bool get hasNextCommonFeeds => _commonFeedsHasNext;

  @override
  List<FeedPresenter<Feed>> get feeds => List.unmodifiable(_commonFeeds + _randomFeeds);

  @override
  int get currentPageNumber => _commonFeedsHasNext ? (_commonFeeds.length / 12).toInt() : (_randomFeeds.length / 12).toInt();

  @override
  bool get hasNext => _commonFeedsHasNext || _randomFeedsHasNext;

  _addCommonItems({required List<Feed> newItems, required bool hasNext}) {
    _commonFeeds.addAll(
      newItems.map(
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
    _commonFeedsHasNext = hasNext;
  }

  _addRandomItems({required List<Feed> newItems, required bool hasNext}) {
    _randomFeeds.addAll(
      newItems.map(
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
    _randomFeedsHasNext = hasNext;
  }

  @override
  addItems({required List<Feed> newItems, required bool hasNext}) {
    if (_commonFeedsHasNext) {
      _addCommonItems(newItems: newItems, hasNext: hasNext);
    } else {
      _addRandomItems(newItems: newItems, hasNext: hasNext);
    }
  }

  @override
  onRefresh() {
    _commonFeeds.clear();
    _randomFeeds.clear();
    _commonFeedsHasNext = true;
    _randomFeedsHasNext = true;
  }
}

final class PostFeedPage implements FeedPage {
  final List<FeedPresenter<Feed>> _feeds = List.empty(growable: true);
  bool _hasNext = true;

  @override
  List<FeedPresenter<Feed>> get feeds => List.unmodifiable(_feeds);

  @override
  int get currentPageNumber => (_feeds.length / 12).toInt();

  @override
  bool get hasNext => _hasNext;

  @override
  addItems({required List<Feed> newItems, required bool hasNext}) {
    _feeds.addAll(
      newItems.map(
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
    _hasNext = hasNext;
  }

  @override
  onRefresh() {
    _feeds.clear();
    _hasNext = true;
  }
}

final class TastedRecordFeedPage implements FeedPage {
  final List<FeedPresenter<Feed>> _feeds = List.empty(growable: true);
  bool _hasNext = true;

  @override
  List<FeedPresenter<Feed>> get feeds => List.unmodifiable(_feeds);

  @override
  int get currentPageNumber => (_feeds.length / 12).toInt();

  @override
  bool get hasNext => _hasNext;

  @override
  addItems({required List<Feed> newItems, required bool hasNext}) {
    _feeds.addAll(
      newItems.map(
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
    _hasNext = hasNext;
  }

  @override
  onRefresh() {
    _feeds.clear();
    _hasNext = true;
  }
}
