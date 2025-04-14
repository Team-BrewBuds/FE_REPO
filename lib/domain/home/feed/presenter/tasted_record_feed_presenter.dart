import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/model/events/tasted_record_like_event.dart';
import 'package:brew_buds/model/events/tasted_record_save_event.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/feed/feed.dart';

typedef BodyState = ({
  String image,
  String rating,
  String type,
  String name,
  List<String> flavors,
  String contents,
  String tag,
});

final class TastedRecordFeedPresenter extends FeedPresenter<TastedRecordFeed> {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository();
  late final StreamSubscription _tastedRecordLikeSub;
  late final StreamSubscription _tastedRecordSaveSub;

  TastedRecordFeedPresenter({
    required super.feed,
  }) {
    _tastedRecordLikeSub = EventBus.instance.on<TastedRecordLikeEvent>().listen(onLikeEvent);
    _tastedRecordSaveSub = EventBus.instance.on<TastedRecordSaveEvent>().listen(onSaveEvent);
  }

  @override
  dispose() {
    _tastedRecordLikeSub.cancel();
    _tastedRecordSaveSub.cancel();
    super.dispose();
  }

  @override
  AuthorState get authorState => (
        imageUrl: feed.data.author.profileImageUrl,
        nickname: feed.data.author.nickname,
        createdAt: feed.data.createdAt,
        viewCount: feed.data.viewCount,
        isFollow: feed.data.isAuthorFollowing,
        isMine: feed.data.author.id == AccountRepository.instance.id,
      );

  @override
  BottomButtonState get bottomButtonState => (
        likeCount: feed.data.likeCount,
        isLiked: feed.data.isLiked,
        commentsCount: feed.data.commentsCount,
        isSaved: feed.data.isSaved,
      );

  String get _tag => feed.data.tag.replaceAll(',', '#');

  BodyState get bodyState => (
        image: feed.data.thumbnailUri,
        rating: '${feed.data.rating}',
        type: feed.data.beanType,
        name: feed.data.beanName,
        flavors: feed.data.flavors,
        contents: feed.data.contents,
        tag: _tag.startsWith('#') ? _tag : '#$_tag',
      );

  @override
  onFollowButtonTap() async {
    final previousTastedRecord = feed.data;
    final isFollow = previousTastedRecord.isAuthorFollowing;
    feed = TastedRecordFeed(data: previousTastedRecord.copyWith(isAuthorFollowing: !isFollow));
    notifyListeners();

    try {
      await _tastedRecordRepository.follow(id: previousTastedRecord.id, isFollow: isFollow);

      EventBus.instance.fire(UserFollowEvent(previousTastedRecord.author.id, !isFollow));
    } catch (_) {
      feed = TastedRecordFeed(data: previousTastedRecord);
      notifyListeners();
    }
  }

  @override
  onLikeButtonTap() async {
    final previousTastedRecord = feed.data;
    final isLiked = previousTastedRecord.isLiked;
    final likeCount = previousTastedRecord.likeCount;
    feed = TastedRecordFeed(data: previousTastedRecord.copyWith(isLiked: !isLiked, likeCount: isLiked ? likeCount - 1 : likeCount + 1));
    notifyListeners();

    try {
      await _tastedRecordRepository.like(id: previousTastedRecord.id, isLiked: isLiked);
    } catch (_) {
      feed = TastedRecordFeed(data: previousTastedRecord);
      notifyListeners();
    }
  }

  @override
  onSaveButtonTap() async {
    final previousTastedRecord = feed.data;
    final isSaved = previousTastedRecord.isSaved;
    feed = TastedRecordFeed(data: previousTastedRecord.copyWith(isSaved: !isSaved));
    notifyListeners();

    try {
      await _tastedRecordRepository.save(id: previousTastedRecord.id, isSaved: isSaved);
    } catch (_) {
      feed = TastedRecordFeed(data: previousTastedRecord);
      notifyListeners();
    }
  }

  @override
  onUserFollowEvent(UserFollowEvent event) {
    if (feed.data.author.id == event.userId) {
      feed = TastedRecordFeed(data: feed.data.copyWith(isAuthorFollowing: event.isFollow));
      notifyListeners();
    }
  }

  onLikeEvent(TastedRecordLikeEvent event) {
    if (feed.data.id == event.id) {
      feed = TastedRecordFeed(data: feed.data.copyWith(isLiked: event.isLiked));
      notifyListeners();
    }
  }

  onSaveEvent(TastedRecordSaveEvent event) {
    if (feed.data.id == event.id) {
      feed = TastedRecordFeed(data: feed.data.copyWith(isSaved: event.isSaved));
      notifyListeners();
    }
  }
}
