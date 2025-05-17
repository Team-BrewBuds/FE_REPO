import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/comments/widget/comment_presenter.dart';
import 'package:brew_buds/model/common/object_type.dart';
import 'package:brew_buds/model/events/comment_event.dart';

final class CommentsPresenter extends Presenter {
  final CommentsRepository _repository = CommentsRepository.instance;
  late final StreamSubscription _eventSub;
  final ObjectType _objectType;
  final int _objectId;
  bool _isLoading = false;
  final List<CommentPresenter> _commentPresenters = [];
  final Map<int, CommentPresenter> _justWroteComments = {};
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

  List<CommentPresenter> get commentPresenters =>
      List.unmodifiable(_justWroteComments.values.toList() + _commentPresenters);

  @override
  dispose() {
    _eventSub.cancel();
    super.dispose();
  }

  _onEvent(CommentEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case CreateCommentEvent():
          if (event.objectId == _objectId && event.objectType == _objectType.toString()) {
            _justWroteComments[event.newComment.id] = CommentPresenter(comment: event.newComment);
            _updateCommentCount(_totalCount + 1);
            notifyListeners();
          }
          break;
        case CreateReCommentEvent():
          if (event.objectId == _objectId && event.objectType == _objectType.toString()) {
            _updateCommentCount(_totalCount + 1);
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }

  Future<void> onRefresh() async {
    if (_isLoading) return;

    _currentPage = 1;
    _justWroteComments.clear();
    _commentPresenters.clear();
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

      _commentPresenters.addAll(
        newPage.results.map(
          (e) {
            _justWroteComments.remove(e.id);
            return CommentPresenter(comment: e);
          },
        ),
      );
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
        objectId: _objectId,
        count: _totalCount,
        objectType: _objectType.toString(),
      ),
    );
    notifyListeners();
  }
}
