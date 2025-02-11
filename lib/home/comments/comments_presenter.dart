import 'dart:async';

import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:brew_buds/model/user.dart';
import 'package:flutter/foundation.dart';

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
  final AccountRepository _accountRepository;
  final CommentsRepository _repository;
  final StreamController<bool> _loadingController = StreamController.broadcast();
  int _currentPage = 0;
  Comment? _replyComment;
  bool _isLoading = false;
  bool _disposed = false;
  CommentsPage _page = CommentsPage.initial();

  CommentsPresenter({
    required bool isPost,
    required int id,
    required this.author,
    required AccountRepository accountRepository,
    required CommentsRepository repository,
  })  : _type = isPost ? _FeedType.post : _FeedType.tastingRecord,
        _id = id,
        _accountRepository = accountRepository,
        _repository = repository {
    isLoadingStream.listen((isLoading) {
      _isLoading = isLoading;
    });
  }

  List<Comment> get comments => _page.comments;

  Stream<bool> get isLoadingStream => _loadingController.stream;

  bool get hasNext => _page.hasNext;

  Comment? get replyComment => _replyComment;

  bool get isReply => _replyComment != null;

  refresh() {
    _currentPage = 0;
    _replyComment = null;
    _page = CommentsPage.initial();
    fetchMoreData();
  }

  initState() {
    fetchMoreData();
  }

  fetchMoreData() async {
    if (hasNext && !_isLoading) {
      _loadingController.add(true);

      final result = await _repository.fetchCommentsPage(feedType: _type.toString(), id: _id, pageNo: _currentPage + 1);
      _page = _page.copyWith(comments: _page.comments + result.comments, hasNext: result.hasNext);
      _currentPage += 1;
      notifyListeners();

      _loadingController.add(false);
    }
  }

  Future<void> createNewComment({required String content}) {
    return _repository
        .createNewComment(feedType: _type.toString(), id: _id, content: content, parentId: _replyComment?.id)
        .then((_) => refresh());
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
    _loadingController.close();
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

  cancelReply() {
    _replyComment = null;
    notifyListeners();
  }

  bool canDelete(int id) {
    return _accountRepository.id == author.id || _accountRepository.id == id;
  }

  _updateComments({required Comment newComment}) {
    _page = _page.copyWith(
      comments: _page.comments.map((comment) => comment.id == newComment.id ? newComment : comment).toList(),
    );
    notifyListeners();
  }
}
