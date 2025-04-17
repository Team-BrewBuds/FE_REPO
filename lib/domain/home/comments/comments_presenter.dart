import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/home/comments/comment_presenter.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:flutter/foundation.dart';

typedef BottomTextFieldState = ({String? reCommentAuthorNickname, String authorNickname});

enum ObjectType {
  post,
  tastingRecord;

  @override
  String toString() => switch (this) {
        ObjectType.post => 'post',
        ObjectType.tastingRecord => 'tasted_record',
      };
}

final class CommentsPresenter extends Presenter {
  final CommentsRepository _repository = CommentsRepository.instance;
  final ObjectType _objectType;
  final int _objectId;
  final User _objectAuthor;
  bool _isLoading = false;
  List<CommentPresenter> _commentPresenters = [];
  int _currentPage = 1;
  bool _hasNext = true;
  int _totalCount = 0;
  CommentPresenter? _replyCommentPresenter;

  CommentsPresenter({
    required ObjectType objectType,
    required int objectId,
    required User objectAuthor,
  })  : _objectType = objectType,
        _objectId = objectId,
        _objectAuthor = objectAuthor;

  bool get isLoading => _isLoading;

  bool get hasNext => _hasNext;

  int get totalCount => _totalCount;

  List<CommentPresenter> get commentPresenters => List.unmodifiable(_commentPresenters);

  bool get isReplyMode => _replyCommentPresenter != null;

  BottomTextFieldState get bottomTextFieldState => (
        reCommentAuthorNickname: _replyCommentPresenter?.nickName,
        authorNickname: _objectAuthor.nickname,
      );

  Future<void> onRefresh() async {
    if (_isLoading) return;

    _currentPage = 1;
    _replyCommentPresenter = null;
    _commentPresenters = List.empty(growable: true);
    _isLoading = true;
    _hasNext = true;

    await fetchMoreData();

    _isLoading = false;
    notifyListeners();
  }

  initState() async {
    _isLoading = true;
    notifyListeners();

    await fetchMoreData();

    _isLoading = false;
    notifyListeners();
  }

  fetchMoreData() async {
    if (hasNext) {
      final newPage = await _repository.fetchCommentsPage(
        feedType: _objectType.toString(),
        id: _objectId,
        pageNo: _currentPage,
      );

      _commentPresenters.addAll(
        newPage.results.map(
          (e) => CommentPresenter(objectId: _objectId, objectAuthorId: _objectAuthor.id, comment: e),
        ),
      );
      _updateCommentCount(newPage.count);
      _hasNext = newPage.hasNext;
      _currentPage += 1;
      notifyListeners();
    }
  }

  Future<void> createNewComment({required String content}) async {
    try {
      final newComment = await _repository.createNewComment(
        feedType: _objectType.toString(),
        id: _objectId,
        content: content,
        parentId: _replyCommentPresenter?.id,
      );

      final parentPresenter = _replyCommentPresenter;

      if (parentPresenter != null) {
        EventBus.instance.fire(
          CreateReCommentEvent(
            senderId: presenterId,
            id: parentPresenter.id,
            newReComment: newComment,
          ),
        );
        cancelReply();
      } else {
        _commentPresenters.insert(
          0,
          CommentPresenter(
            objectId: _objectId,
            objectAuthorId: _objectAuthor.id,
            comment: newComment,
          ),
        );
        notifyListeners();
      }
      _updateCommentCount(totalCount + 1);
    } catch (_) {
      if (_replyCommentPresenter != null) {
        throw ErrorDescription('대댓글 작성에 실패했어요.');
      } else {
        throw ErrorDescription('댓글 작성에 실패했어요.');
      }
    }
  }

  onTapDeleteCommentAt(int index) async {
    final removedComment = _commentPresenters.removeAt(index);
    notifyListeners();

    try {
      await _repository.deleteComment(id: removedComment.id);
    } catch (e) {
      _commentPresenters.insert(index, removedComment);
      notifyListeners();
      return;
    }
  }

  onTappedReplyAt(int index) {
    final presenter = _commentPresenters.elementAtOrNull(index);
    if (presenter != null) {
      _replyCommentPresenter = presenter;
      notifyListeners();
    }
  }

  cancelReply() {
    _replyCommentPresenter = null;
    notifyListeners();
  }

  _updateCommentCount(int count) {
    if (_totalCount != count) {
      _totalCount = count;
      EventBus.instance.fire(
        OnChangeCommentCountEvent(
            senderId: presenterId,
            id: _objectId,
            count: count,
            objectType: _objectType == ObjectType.post ? 'post' : 'tasted_record'),
      );
      notifyListeners();
    }
  }
}
