import 'dart:async';

import 'package:brew_buds/core/presenter.dart';
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

final class CommentsPresenter extends Presenter {
  final _FeedType _type;
  final int _id;
  final User author;
  final CommentsRepository _repository = CommentsRepository.instance;
  bool _isLoading = false;
  int _currentPage = 0;
  Comment? _replyComment;
  DefaultPage<Comment> _page = DefaultPage.initState();

  CommentsPresenter({
    required bool isPost,
    required int id,
    required this.author,
  })  : _type = isPost ? _FeedType.post : _FeedType.tastingRecord,
        _id = id;

  bool get isLoading => _isLoading;

  DefaultPage<Comment> get page => _page;

  BottomTextFieldState get bottomTextFieldState => (
        reCommentAuthorNickname: _replyComment?.author.nickname,
        authorNickname: author.nickname,
      );

  refresh() async {
    _currentPage = 0;
    _replyComment = null;
    _page = DefaultPage.initState();
    _isLoading = true;
    notifyListeners();

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
    if (_page.hasNext) {
      final newPage = await _repository.fetchCommentsPage(
        feedType: _type.toString(),
        id: _id,
        pageNo: _currentPage + 1,
      );
      _page = await compute(
        (message) {
          return message.$2.copyWith(
            results: message.$1.results +
                message.$2.results.where((element) => !message.$1.results.contains(element)).toList(),
          );
        },
        (_page, newPage),
      );
      _currentPage += 1;
      notifyListeners();
    }
  }

  Future<void> createNewComment({required String content}) async {
    try {
      final parentId = _replyComment?.id;
      await _repository.createNewComment(feedType: _type.toString(), id: _id, content: content, parentId: parentId);
      if (parentId != null) {
        final newParentComment = await _repository.fetchComment(id: parentId);
        _page = await compute(
          (message) => message.$1.copyWith(
            results: List<Comment>.from(message.$1.results).map((e) => e.id == message.$2.id ? message.$2 : e).toList(),
          ),
          (_page, newParentComment),
        );
        notifyListeners();
      } else {
        refresh();
      }
    } catch (_) {
      rethrow;
    }
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

  _updateComments({required Comment newComment}) async {
    _page = await compute((message) {
      final parentId = message.$2.parentId;
      if (parentId != null) {
        return message.$1.copyWith(
            results: List<Comment>.from(message.$1.results).map((comment) {
          if (comment.id == parentId) {
            return comment.copyWith(
              reComments: List<Comment>.from(comment.reComments)
                  .map((reComment) => reComment.id == message.$2.id ? message.$2 : reComment)
                  .toList(),
            );
          } else {
            return comment;
          }
        }).toList());
      } else {
        return message.$1.copyWith(
          results: List<Comment>.from(message.$1.results)
              .map((comment) => comment.id == message.$2.id ? message.$2 : comment)
              .toList()
        );
      }
    }, (_page, newComment));
    notifyListeners();
  }
}
