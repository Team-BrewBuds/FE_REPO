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
  final CommentsRepository _repository;
  int _currentPage = 0;
  bool _disposed = false;
  CommentsPage _page = CommentsPage.initial();

  CommentsPresenter({
    required bool isPost,
    required int id,
    required this.author,
    required CommentsRepository repository,
  })  : _type = isPost ? _FeedType.post : _FeedType.tastingRecord,
        _id = id,
        _repository = repository;

  List<Comment> get comments => _page.comments;

  bool get hasNext => _page.hasNext;

  refresh() {
    _currentPage = 0;
    _page = CommentsPage.initial();
    fetchMoreData();
  }

  initState() {
    fetchMoreData();
  }

  fetchMoreData() async {
    if (hasNext) {
      final result = await _repository.fetchCommentsPage(feedType: _type.toString(), id: _id, pageNo: _currentPage + 1);
      _page = _page.copyWith(comments: _page.comments + result.comments, hasNext: result.hasNext);
      _currentPage += 1;
      notifyListeners();
    }
  }

  createNewComment({required String content}) {
    _repository.createNewComment(feedType: _type.toString(), id: _id, content: content).then((_) => refresh());
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
}
