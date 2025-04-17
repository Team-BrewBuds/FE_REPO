import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/domain/home/feed/presenter/feed_presenter.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/post_event.dart';
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
  late final StreamSubscription _postSub;
  late final StreamSubscription _commentSub;

  PostFeedPresenter({
    required super.feed,
  }) {
    _postSub = EventBus.instance.on<PostEvent>().listen(_onEvent);
    _commentSub = EventBus.instance.on<CommentEvent>().listen(_onCommentEvent);
  }

  @override
  dispose() {
    _postSub.cancel();
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
        subject: feed.data.subject,
        title: feed.data.title,
        contents: feed.data.contents,
        tag: _tag.startsWith('#')
            ? _tag
            : _tag.isNotEmpty
                ? '#$_tag'
                : '',
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
      EventBus.instance.fire(
        UserFollowEvent(
          senderId: presenterId,
          userId: previousPost.author.id,
          isFollow: !isFollow,
        ),
      );
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
      EventBus.instance.fire(
        PostLikeEvent(
          senderId: presenterId,
          id: feed.data.id,
          isLiked: !isLiked,
          likeCount: isLiked ? likeCount - 1 : likeCount + 1,
        ),
      );
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
      EventBus.instance.fire(PostSaveEvent(senderId: presenterId, id: feed.data.id, isSaved: !isSaved));
    } catch (_) {
      feed = PostFeed(data: previousPost);
      notifyListeners();
    }
  }

  @override
  onUserFollowEvent(UserFollowEvent event) {
    if (feed.data.author.id == event.userId && feed.data.isAuthorFollowing != event.isFollow) {
      feed = PostFeed(data: feed.data.copyWith(isAuthorFollowing: event.isFollow));
      notifyListeners();
    }
  }

  _onEvent(PostEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case PostLikeEvent():
          final id = feed.data.id;
          final isLiked = feed.data.isLiked;
          final likeCount = feed.data.likeCount;
          if (id == event.id && (isLiked != event.isLiked || likeCount != event.likeCount)) {
            feed = PostFeed(data: feed.data.copyWith(isLiked: event.isLiked, likeCount: event.likeCount));
            notifyListeners();
          }
          break;
        case PostSaveEvent():
          final id = feed.data.id;
          final isSaved = feed.data.isSaved;
          if (id == event.id && isSaved != event.isSaved) {
            feed = PostFeed(data: feed.data.copyWith(isSaved: event.isSaved));
            notifyListeners();
          }
          break;
        case PostUpdateEvent():
          final post = event.post;
          if (post.id == feed.data.id) {
            feed = PostFeed(
              data: feed.data.copyWith(
                title: post.title,
                subject: post.subject,
                contents: post.contents,
                tag: post.tag,
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
    if (event.senderId != presenterId && event.id == feed.data.id) {
      switch (event) {
        case OnChangeCommentCountEvent():
          if (event.objectType == 'post') {
            feed = PostFeed(data: feed.data.copyWith(commentsCount: event.count));
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }
}
