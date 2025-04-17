import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/home/comments/re_comment_presenter.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/events/comment_event.dart';

final class CommentPresenter extends Presenter {
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  late final StreamSubscription _eventSub;
  final int objectId;
  final int objectAuthorId;
  Comment _comment;
  List<ReCommentPresenter> _reCommentPresenters;
  bool _isExpanded = false;

  int get id => _comment.id;

  int get authorId => _comment.author.id;

  bool get isExpanded => _isExpanded;

  String get profileImageUrl => _comment.author.profileImageUrl;

  String get nickName => _comment.author.nickname;

  String get createdAt => _comment.createdAt;

  bool get isWriter => _comment.author.id == objectAuthorId;

  bool get isMyObject => objectAuthorId == AccountRepository.instance.id;

  bool get isMyComment => _comment.author.id == AccountRepository.instance.id;

  String get contents => _comment.content;

  bool get isLiked => _comment.isLiked;

  int get likeCount => _comment.likeCount;

  List<ReCommentPresenter> get reCommentPresenters => List.unmodifiable(_reCommentPresenters);

  CommentPresenter({
    required this.objectId,
    required this.objectAuthorId,
    required Comment comment,
  })  : _comment = comment,
        _reCommentPresenters = List.from(
          comment.reComments.map(
            (e) => ReCommentPresenter(
              isWriter: comment.author.id == objectAuthorId,
              isMyObject: objectAuthorId == AccountRepository.instance.id,
              comment: e,
            ),
          ),
        ) {
    _eventSub = EventBus.instance.on<CommentEvent>().listen(_onEvent);
  }

  @override
  dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  onTapExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  _onEvent(CommentEvent event) {
    if (event.senderId != presenterId && event.id == _comment.id) {
      switch (event) {
        case CommentLikeEvent():
          _comment = _comment.copyWith(isLiked: event.isLiked, likeCount: event.likeCount);
          notifyListeners();
          break;
        case CreateReCommentEvent():
          _reCommentPresenters.add(
            ReCommentPresenter(
              isWriter: isWriter,
              isMyObject: isMyObject,
              comment: event.newReComment,
            ),
          );
          notifyListeners();
          break;
        case CommentUpdateEvent():
          updateComment();
          break;
        default:
          break;
      }
    }
  }

  updateComment() async {
    try {
      final newComment = await _commentsRepository.fetchComment(id: _comment.id);
      _comment = newComment.copyWith();
      _reCommentPresenters = newComment.reComments
          .map(
            (e) => ReCommentPresenter(
              isWriter: e.author.id == objectAuthorId,
              isMyObject: e.author.id == AccountRepository.instance.id,
              comment: e,
            ),
          )
          .toList();
      notifyListeners();
    } catch (e) {
      return;
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

  onTapDeleteReCommentAt(int index) async {
    final removedComment = _reCommentPresenters.removeAt(index);
    notifyListeners();

    try {
      await _commentsRepository.deleteComment(id: removedComment.id);
    } catch (e) {
      _reCommentPresenters.insert(index, removedComment);
      return;
    }
  }
}
