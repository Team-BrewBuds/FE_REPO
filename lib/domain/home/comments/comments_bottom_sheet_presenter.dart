import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/domain/home/comments/comments_presenter.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/events/comment_event.dart';

typedef BottomTextFieldState = ({String? reCommentAuthorNickname, String authorNickname});

typedef ReplyState = ({User user, int id});

final class CommentsBottomSheetPresenter extends Presenter {
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  final ObjectType _objectType;
  final int _objectId;
  final User _author;
  User? _replyUser;
  int? _parentsId;

  int get authorId => _author.id;

  User? get replyUser => _replyUser;

  String get nickname => _author.nickname;

  BottomTextFieldState get bottomTextFieldState => (
        reCommentAuthorNickname: _replyUser?.nickname,
        authorNickname: _author.nickname,
      );

  CommentsBottomSheetPresenter({
    required ObjectType objectType,
    required int objectId,
    required User author,
  })  : _objectType = objectType,
        _objectId = objectId,
        _author = author;

  bool isWriter(int authorId) {
    return authorId == _author.id;
  }

  bool isMine(int authorId) {
    return authorId == AccountRepository.instance.id;
  }

  bool isMyObject() {
    return _author.id == AccountRepository.instance.id;
  }

  selectedReply(User user, int id) {
    _replyUser = user;
    _parentsId = id;
    notifyListeners();
  }

  cancelReply() {
    _replyUser = null;
    _parentsId = null;
    notifyListeners();
  }

  Future<void> createNewComment({required String content}) async {
    try {
      final newComment = await _commentsRepository.createNewComment(
        feedType: _objectType.toString(),
        id: _objectId,
        content: content,
        parentId: _parentsId,
      );

      final parentId = _parentsId;

      if (parentId != null) {
        EventBus.instance.fire(
          CreateReCommentEvent(
            senderId: presenterId,
            parentId: parentId,
            objectId: _objectId,
            objectType: _objectType.toString(),
            newReComment: newComment,
          ),
        );
      } else {
        EventBus.instance.fire(
          CreateCommentEvent(
            senderId: presenterId,
            objectId: _objectId,
            newComment: newComment,
            objectType: _objectType.toString(),
          ),
        );
      }
      _replyUser = null;
      _parentsId = null;
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
