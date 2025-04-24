import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/home/comments/comment_presenter.dart';
import 'package:brew_buds/model/events/comment_event.dart';

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
  late final StreamSubscription _eventSub;
  final ObjectType _objectType;
  final int _objectId;
  bool _isLoading = false;
  List<CommentPresenter> _commentPresenters = [];
  CommentPresenter? _justWroteComment;
  int _currentPage = 1;
  bool _hasNext = true;
  int _totalCount = 0;

  CommentsPresenter({
    required ObjectType objectType,
    required int objectId,
  })  : _objectType = objectType,
        _objectId = objectId {
    _eventSub = EventBus.instance.on<CommentEvent>().listen(_onEvent);
    fetchMoreData();
  }

  bool get isLoading => _isLoading && _commentPresenters.isEmpty;

  bool get hasNext => _hasNext;

  int get totalCount => _totalCount;

  List<CommentPresenter> get commentPresenters {
    if (_justWroteComment != null) {
      return List.unmodifiable([_justWroteComment] + _commentPresenters);
    } else {
      return List.unmodifiable(_commentPresenters);
    }
  }

  @override
  dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  _onEvent(CommentEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case CreateCommentEvent():
          if (event.id == _objectId) {
            _commentPresenters.insert(0, CommentPresenter(comment: event.newComment));
            _updateCommentCount(_totalCount + 1);
            notifyListeners();
          }
          break;
        case CreateReCommentEvent():
          _updateCommentCount(_totalCount + 1);
          notifyListeners();
          break;
        default:
          break;
      }
    }
  }

  Future<void> onRefresh() async {
    if (_isLoading) return;

    _justWroteComment = null;
    _currentPage = 1;
    _commentPresenters = List.empty(growable: true);
    _hasNext = true;

    await fetchMoreData(isRefresh: true);
  }

  fetchMoreData({bool isRefresh = false}) async {
    if (hasNext && !_isLoading) {
      _isLoading = true;
      if (!isRefresh) {
        notifyListeners();
      }

      final newPage = await _repository.fetchCommentsPage(
        feedType: _objectType.toString(),
        id: _objectId,
        pageNo: _currentPage,
      );

      _commentPresenters.addAll(newPage.results.map((e) => CommentPresenter(comment: e)));
      if (newPage.count != _totalCount) {
        _updateCommentCount(newPage.count);
      }
      _hasNext = newPage.hasNext;
      _currentPage += 1;
      _isLoading = false;
      notifyListeners();
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

  _updateCommentCount(int count) {
    _totalCount = count;
    EventBus.instance.fire(
      OnChangeCommentCountEvent(
        senderId: presenterId,
        id: _objectId,
        count: _totalCount,
        objectType: _objectType.toString(),
      ),
    );
    notifyListeners();
  }
}
