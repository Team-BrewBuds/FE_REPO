import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/model/events/post_like_event.dart';
import 'package:brew_buds/model/events/post_save_event.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';

typedef BodyState = ({
  PostSubject subject,
  String title,
  String contents,
  String tag,
  List<String> images,
  List<TastedRecordInPost> tastedRecords,
});

final class PostFeedPresenter extends FeedPresenter<PostFeed> {
  final PostRepository _postRepository = PostRepository();
  late final StreamSubscription _postLikeSub;
  late final StreamSubscription _postSaveSub;

  PostFeedPresenter({
    required super.feed,
  }) {
    _postLikeSub = EventBus.instance.on<PostLikeEvent>().listen(onLikeEvent);
    _postSaveSub = EventBus.instance.on<PostSaveEvent>().listen(onSaveEvent);
  }

  @override
  dispose() {
    _postLikeSub.cancel();
    _postSaveSub.cancel();
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
        subject: feed.data.subject,
        title: feed.data.title,
        contents: feed.data.contents,
        tag: _tag.startsWith('#') ? _tag : _tag.isNotEmpty ? '#$_tag' : '',
        images: feed.data.imagesUrl,
        tastedRecords: feed.data.tastingRecords,
      );

  @override
  onFollowButtonTap() async {
    final previousPost = feed.data;
    final isFollow = previousPost.isAuthorFollowing;
    feed = PostFeed(data: previousPost.copyWith(isAuthorFollowing: !isFollow));
    notifyListeners();

    try {
      await _postRepository.follow(post: previousPost);

      EventBus.instance.fire(UserFollowEvent(previousPost.author.id, !isFollow));
    } catch (_) {
      feed = PostFeed(data: previousPost);
      notifyListeners();
    }
  }

  @override
  onLikeButtonTap() async {
    final previousPost = feed.data;
    final isLiked = previousPost.isLiked;
    final likeCount = previousPost.likeCount;
    feed = PostFeed(data: previousPost.copyWith(isLiked: !isLiked, likeCount: isLiked ? likeCount - 1 : likeCount + 1));
    notifyListeners();

    try {
      await _postRepository.like(post: previousPost);
    } catch (_) {
      feed = PostFeed(data: previousPost);
      notifyListeners();
    }
  }

  @override
  onSaveButtonTap() async {
    final previousPost = feed.data;
    final isSaved = previousPost.isSaved;
    feed = PostFeed(data: previousPost.copyWith(isSaved: !isSaved));
    notifyListeners();

    try {
      await _postRepository.save(post: previousPost);
    } catch (_) {
      feed = PostFeed(data: previousPost);
      notifyListeners();
    }
  }

  @override
  onUserFollowEvent(UserFollowEvent event) {
    if (feed.data.author.id == event.userId) {
      feed = PostFeed(data: feed.data.copyWith(isAuthorFollowing: event.isFollow));
      notifyListeners();
    }
  }

  onLikeEvent(PostLikeEvent event) {
    if (feed.data.id == event.id) {
      feed = PostFeed(data: feed.data.copyWith(isLiked: event.isLiked));
      notifyListeners();
    }
  }

  onSaveEvent(PostSaveEvent event) {
    if (feed.data.id == event.id) {
      feed = PostFeed(data: feed.data.copyWith(isSaved: event.isSaved));
      notifyListeners();
    }
  }
}
