import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/tasted_record_event.dart';
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
  late final StreamSubscription _tastedRecordSub;
  late final StreamSubscription _commentSub;

  TastedRecordFeedPresenter({
    required super.feed,
  }) {
    _tastedRecordSub = EventBus.instance.on<TastedRecordEvent>().listen(_onEvent);
    _commentSub = EventBus.instance.on<CommentEvent>().listen(_onCommentEvent);
  }

  @override
  dispose() {
    _tastedRecordSub.cancel();
    _commentSub.cancel();
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
      EventBus.instance.fire(
        UserFollowEvent(
          senderId: presenterId,
          userId: previousTastedRecord.author.id,
          isFollow: !isFollow,
        ),
      );
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
    feed = TastedRecordFeed(
      data: previousTastedRecord.copyWith(
        isLiked: !isLiked,
        likeCount: isLiked ? likeCount - 1 : likeCount + 1,
      ),
    );
    notifyListeners();

    try {
      await _tastedRecordRepository.like(id: previousTastedRecord.id, isLiked: isLiked);
      EventBus.instance.fire(
        TastedRecordLikeEvent(
          senderId: presenterId,
          id: feed.data.id,
          isLiked: !isLiked,
          likeCount: isLiked ? likeCount - 1 : likeCount + 1,
        ),
      );
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
      EventBus.instance.fire(TastedRecordSaveEvent(senderId: presenterId, id: feed.data.id, isSaved: !isSaved));
    } catch (_) {
      feed = TastedRecordFeed(data: previousTastedRecord);
      notifyListeners();
    }
  }

  @override
  onUserFollowEvent(UserFollowEvent event) {
    if (feed.data.author.id == event.userId && feed.data.isAuthorFollowing != event.isFollow) {
      feed = TastedRecordFeed(data: feed.data.copyWith(isAuthorFollowing: event.isFollow));
      notifyListeners();
    }
  }

  _onEvent(TastedRecordEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case TastedRecordLikeEvent():
          final id = feed.data.id;
          final isLiked = feed.data.isLiked;
          final likeCount = feed.data.likeCount;
          if (id == event.id && (isLiked != event.isLiked || likeCount != event.likeCount)) {
            feed = TastedRecordFeed(data: feed.data.copyWith(isLiked: event.isLiked, likeCount: event.likeCount));
            notifyListeners();
          }
          break;
        case TastedRecordSaveEvent():
          final id = feed.data.id;
          final isSaved = feed.data.isSaved;
          if (id == event.id && isSaved != event.isSaved) {
            feed = TastedRecordFeed(data: feed.data.copyWith(isSaved: event.isSaved));
            notifyListeners();
          }
          break;
        case TastedRecordUpdateEvent():
          if (event.id == feed.data.id) {
            final updateModel = event.updateModel;
            feed = TastedRecordFeed(
              data: feed.data.copyWith(
                rating: updateModel.tasteReview.star,
                flavors: List.from(updateModel.tasteReview.flavors),
                contents: updateModel.contents,
                tag: updateModel.tag,
              ),
            );
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }

  _onCommentEvent(CommentEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case OnChangeCommentCountEvent():
          if (event.objectType == 'tasted_record' && event.objectId == feed.data.id) {
            feed = TastedRecordFeed(data: feed.data.copyWith(commentsCount: event.count));
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }
}
