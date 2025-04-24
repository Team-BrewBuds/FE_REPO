import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/events/comment_event.dart';

final class ReCommentPresenter extends Presenter {
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  late final StreamSubscription _eventSub;
  Comment _comment;

  int get id => _comment.id;

  int get authorId => _comment.author.id;

  String get profileImageUrl => _comment.author.profileImageUrl;

  String get nickName => _comment.author.nickname;

  String get createdAt => _comment.createdAt;

  bool get isMyComment => _comment.author.id == AccountRepository.instance.id;

  String get contents => _comment.content;

  bool get isLiked => _comment.isLiked;

  int get likeCount => _comment.likeCount;

  List<Comment> get reComments => _comment.reComments;

  ReCommentPresenter({
    required Comment comment,
  }) : _comment = comment {
    _eventSub = EventBus.instance.on<CommentEvent>().listen(_onEvent);
  }

  @override
  dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  _onEvent(CommentEvent event) {
    if (event.senderId != presenterId && event.id == _comment.id) {
      switch (event) {
        case CommentLikeEvent():
          _comment = _comment.copyWith(isLiked: event.isLiked, likeCount: event.likeCount);
          notifyListeners();
          break;
        default:
          break;
      }
    }
  }

  onTapLike() async {
    final isLikedPre = _comment.isLiked;
    final likeCountPre = _comment.likeCount;
    _comment = _comment.copyWith(isLiked: !isLikedPre, likeCount: isLikedPre ? likeCountPre - 1 : likeCountPre + 1);
    notifyListeners();

    try {
      if (isLikedPre) {
        await _commentsRepository.unLikeComment(id: _comment.id);
      } else {
        await _commentsRepository.likeComment(id: _comment.id);
      }
      EventBus.instance.fire(
        CommentLikeEvent(
          senderId: presenterId,
          id: _comment.id,
          isLiked: !isLikedPre,
          likeCount: isLikedPre ? likeCountPre - 1 : likeCountPre + 1,
        ),
      );
    } catch (e) {
      _comment = _comment.copyWith(isLiked: isLikedPre, likeCount: likeCountPre);
      notifyListeners();
    }
  }
}
