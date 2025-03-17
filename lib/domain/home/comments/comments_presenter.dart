import 'dart:async';

import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:flutter/foundation.dart';

typedef BottomTextFieldState = ({String? reCommentAuthorNickname, String authorNickname});

enum _FeedType {
  post,
  tastingRecord;

  @override
  String toString() => switch (this) { _FeedType.post => 'post', _FeedType.tastingRecord => 'tasted_record' };
}

final class CommentsPresenter extends ChangeNotifier {
  final _FeedType _type;
  final int _id;
  final User author;
  final CommentsRepository _repository = CommentsRepository.instance;
  int _currentPage = 0;
  Comment? _replyComment;
  bool _disposed = false;
  DefaultPage<Comment> _page = DefaultPage.initState();

  CommentsPresenter({
    required bool isPost,
    required int id,
    required this.author,
    required AccountRepository accountRepository,
    required CommentsRepository repository,
  })  : _type = isPost ? _FeedType.post : _FeedType.tastingRecord,
        _id = id;

  DefaultPage<Comment> get page => _page;

  BottomTextFieldState get bottomTextFieldState => (
        reCommentAuthorNickname: _replyComment?.author.nickname,
        authorNickname: author.nickname,
      );

  refresh() {
    _currentPage = 0;
    _replyComment = null;
    _page = DefaultPage.initState();
    fetchMoreData();
  }

  initState() {
    fetchMoreData();
  }

  fetchMoreData() async {
    if (_page.hasNext) {
      final newPage = await _repository.fetchCommentsPage(
        feedType: _type.toString(),
        id: _id,
        pageNo: _currentPage + 1,
      );
      _page = _page.copyWith(
        results: _page.results + newPage.results.where((element) => !_page.results.contains(element)).toList(),
        hasNext: newPage.hasNext,
      );
      _currentPage += 1;
      notifyListeners();
    }
  }

  Future<void> createNewComment({required String content}) {
    final parentId = _replyComment?.id;
    return _repository
        .createNewComment(feedType: _type.toString(), id: _id, content: content, parentId: parentId)
        .then((newComment) {
      if (parentId != null) {
        _repository.fetchComment(id: parentId).then((newParentComment) {
          _page = _page.copyWith(
            results: List<Comment>.from(_page.results).map((e) => e.id == parentId ? newParentComment : e).toList(),
          );
          _replyComment = null;
          notifyListeners();
        });
      } else {
        refresh();
      }
    });
  }

  deleteComment({required Comment comment}) {
    _repository.deleteComment(id: comment.id).then((_) => refresh());
  }

  onTappedLikeButton({required Comment comment}) {
    if (comment.isLiked) {
      _unLikeComment(comment: comment);
    } else {
      _likeComment(comment: comment);
    }
  }

  _likeComment({required Comment comment}) {
    _repository
        .likeComment(id: comment.id)
        .then((_) => _updateComments(newComment: comment.copyWith(isLiked: true, likeCount: comment.likeCount + 1)));
  }

  _unLikeComment({required Comment comment}) {
    _repository
        .unLikeComment(id: comment.id)
        .then((_) => _updateComments(newComment: comment.copyWith(isLiked: false, likeCount: comment.likeCount - 1)));
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  onTappedReply(Comment comment) {
    _replyComment = comment;
    notifyListeners();
  }

  bool isMine(Comment comment) {
    return comment.author.id == AccountRepository.instance.id;
  }

  cancelReply() {
    _replyComment = null;
    notifyListeners();
  }

  bool canDelete(int id) {
    return AccountRepository.instance.id == author.id || AccountRepository.instance.id == id;
  }

  _updateComments({required Comment newComment}) {
    final parentId = newComment.parentId;
    if (parentId != null) {
      _page = _page.copyWith(
        results: List<Comment>.from(_page.results).map((comment) {
          if (comment.id == parentId) {
            return comment.copyWith(
              reComments: List<Comment>.from(comment.reComments)
                  .map((reComment) => reComment.id == newComment.id ? newComment : reComment)
                  .toList(),
            );
          } else {
            return comment;
          }
        }).toList(),
      );
      notifyListeners();
    } else {
      _page = _page.copyWith(
        results: List<Comment>.from(_page.results).map((comment) => comment.id == newComment.id ? newComment : comment).toList(),
      );
      notifyListeners();
    }
  }
}
