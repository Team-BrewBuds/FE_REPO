import 'dart:async';

import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/exception/comments_exception.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/tasted_record_event.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:korean_profanity_filter/korean_profanity_filter.dart';

typedef BottomButtonInfo = ({int likeCount, bool isLiked, bool isSaved});
typedef ProfileInfo = ({String nickName, int? authorId, String profileImageUrl, bool isFollow});
typedef ContentsInfo = ({double rating, List<String> flavors, String tastedAt, String contents, String location});
typedef BeanInfo = ({
  String? beanType,
  List<String>? country,
  String? region,
  List<String>? process,
  String? variety,
  String? extraction,
  String? roastery,
  String? roastingPoint,
});
typedef CommentTextFieldState = ({String? prentCommentAuthorNickname, String authorNickname});

final class TastedRecordPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  final BlockApi _blockApi = BlockApi();
  final int id;
  late final StreamSubscription _tastedRecordSub;
  late final StreamSubscription _followEventSub;
  bool _isEmpty = false;
  TastedRecord? _tastedRecord;
  User? _replyUser;
  int? _parentsId;

  int? get beanId => _tastedRecord?.bean.id;

  bool? get isOfficial => _tastedRecord?.bean.isOfficial;

  int? get authorId => _tastedRecord?.author.id;

  String? get authorNickname => _tastedRecord?.author.nickname;

  bool get isEmpty => _isEmpty;

  TastedRecord? get tastedRecord => _tastedRecord;

  List<String> get imageUrlList => _tastedRecord?.imagesUrl ?? [];

  BottomButtonInfo get bottomButtonInfo => (
        likeCount: _tastedRecord?.likeCount ?? 0,
        isLiked: _tastedRecord?.isLiked ?? false,
        isSaved: _tastedRecord?.isSaved ?? false,
      );

  String get title => _tastedRecord?.bean.name ?? '';

  ProfileInfo get profileInfo => (
        nickName: _tastedRecord?.author.nickname ?? '',
        authorId: _tastedRecord?.author.id,
        profileImageUrl: _tastedRecord?.author.profileImageUrl ?? '',
        isFollow: _tastedRecord?.isAuthorFollowing ?? false,
      );

  ContentsInfo get contentsInfo => (
        rating: _tastedRecord?.tastingReview.star ?? 0,
        flavors: _tastedRecord?.tastingReview.flavors ?? [],
        tastedAt: _tastedRecord?.tastingReview.tastedAt ?? '',
        contents: _tastedRecord?.contents ?? '',
        location: _tastedRecord?.tastingReview.place ?? '',
      );

  TasteReview? get tastingReview => _tastedRecord?.tastingReview;

  String? get beanType {
    final type = _tastedRecord?.bean.type.toString();
    final isDecaf = _tastedRecord?.bean.isDecaf;
    if (type != null && isDecaf != null) {
      return '$type${isDecaf ? '(디카페인)' : ''}';
    } else if (type != null && isDecaf == null) {
      return type;
    } else {
      return null;
    }
  }

  BeanInfo get beanInfo => (
        beanType: beanType,
        country: _tastedRecord?.bean.country,
        region: _tastedRecord?.bean.region,
        process: _tastedRecord?.bean.process,
        variety: _tastedRecord?.bean.variety,
        extraction: _tastedRecord?.bean.extraction,
        roastery: _tastedRecord?.bean.roastery,
        roastingPoint: roastingPointToString(_tastedRecord?.bean.roastPoint),
      );

  CommentTextFieldState get commentTextFieldState => (
        prentCommentAuthorNickname: _replyUser?.nickname,
        authorNickname: _tastedRecord?.author.nickname ?? '',
      );

  TastedRecordPresenter({
    required this.id,
  }) {
    _tastedRecordSub = EventBus.instance.on<TastedRecordEvent>().listen(_onTastedRecordEvent);
    _followEventSub = EventBus.instance.on<UserFollowEvent>().listen(_onFollowEvent);
    _fetchTastedRecord();
  }

  @override
  dispose() {
    _tastedRecordSub.cancel();
    _followEventSub.cancel();
    super.dispose();
  }

  _onFollowEvent(UserFollowEvent event) {
    if (event.senderId != presenterId && event.userId == _tastedRecord?.author.id) {
      _tastedRecord = _tastedRecord?.copyWith(isAuthorFollowing: event.isFollow);
      notifyListeners();
    }
  }

  _onTastedRecordEvent(TastedRecordEvent event) {
    if (event.senderId != presenterId) {
      switch (event) {
        case TastedRecordDeleteEvent():
          if (event.id == id) {}
          break;
        case TastedRecordUpdateEvent():
          if (event.id == id) {
            final updateModel = event.updateModel;
            _tastedRecord = _tastedRecord?.copyWith(
              contents: updateModel.contents,
              tag: updateModel.tag,
              tastingReview: updateModel.tasteReview,
            );
            notifyListeners();
          }
          break;
        case TastedRecordLikeEvent():
          if (event.id == id) {
            _tastedRecord = _tastedRecord?.copyWith(isLiked: event.isLiked, likeCount: event.likeCount);
            notifyListeners();
          }
          break;
        case TastedRecordSaveEvent():
          if (event.id == id) {
            _tastedRecord = _tastedRecord?.copyWith(isSaved: event.isSaved);
            notifyListeners();
          }
          break;
        default:
          break;
      }
    }
  }

  onRefresh() {
    _fetchTastedRecord();
  }

  _fetchTastedRecord() async {
    _tastedRecord = await _tastedRecordRepository
        .fetchTastedRecord(id: id)
        .then((value) => Future<TastedRecord?>.value(value))
        .onError((error, stackTrace) => null);
    if (_tastedRecord == null) {
      _isEmpty = true;
    }
    notifyListeners();
  }

  Future<void> onDelete() async {
    try {
      await _tastedRecordRepository.delete(id: id);
      EventBus.instance.fire(TastedRecordDeleteEvent(senderId: presenterId, id: id));
    } catch (_) {
      rethrow;
    }
  }

  Future<void> onBlock() {
    final authorId = _tastedRecord?.author.id;
    if (authorId != null) {
      return _blockApi.block(id: authorId);
    } else {
      throw Exception();
    }
  }

  onTappedFollowButton() async {
    final currentTastedRecord = _tastedRecord;
    if (currentTastedRecord != null) {
      final isFollow = currentTastedRecord.isAuthorFollowing;
      _tastedRecord = currentTastedRecord.copyWith(isAuthorFollowing: !isFollow);
      notifyListeners();

      try {
        await _tastedRecordRepository.follow(id: currentTastedRecord.author.id, isFollow: isFollow);
        EventBus.instance.fire(
          UserFollowEvent(
            senderId: presenterId,
            userId: currentTastedRecord.author.id,
            isFollow: !isFollow,
          ),
        );
      } catch (e) {
        _tastedRecord = currentTastedRecord.copyWith(isAuthorFollowing: isFollow);
        notifyListeners();
      }
    }
  }

  onTappedLikeButton() async {
    final currentTastedRecord = _tastedRecord;
    if (currentTastedRecord != null) {
      final isLiked = currentTastedRecord.isLiked;
      final likeCount = currentTastedRecord.likeCount;
      _tastedRecord = currentTastedRecord.copyWith(
        isLiked: !isLiked,
        likeCount: isLiked ? likeCount - 1 : likeCount + 1,
      );
      notifyListeners();

      try {
        await _tastedRecordRepository.like(id: id, isLiked: isLiked);
        EventBus.instance.fire(
          TastedRecordLikeEvent(
            senderId: presenterId,
            id: id,
            isLiked: !isLiked,
            likeCount: isLiked ? likeCount - 1 : likeCount + 1,
          ),
        );
      } catch (e) {
        _tastedRecord = currentTastedRecord.copyWith(isLiked: isLiked, likeCount: likeCount);
        notifyListeners();
      }
    }
  }

  onTappedSaveButton() async {
    final currentTastedRecord = _tastedRecord;
    if (currentTastedRecord != null) {
      final isSaved = currentTastedRecord.isSaved;
      _tastedRecord = currentTastedRecord.copyWith(isSaved: !isSaved);
      notifyListeners();

      try {
        await _tastedRecordRepository.save(id: id, isSaved: isSaved);
        EventBus.instance.fire(
          TastedRecordSaveEvent(
            senderId: presenterId,
            id: id,
            isSaved: !isSaved,
          ),
        );
      } catch (e) {
        _tastedRecord = currentTastedRecord.copyWith(isSaved: isSaved);
        notifyListeners();
      }
    }
  }

  bool isWriter(int authorId) {
    return authorId == _tastedRecord?.author.id;
  }

  bool isMine(int authorId) {
    return authorId == AccountRepository.instance.id;
  }

  bool isMyObject() {
    return _tastedRecord?.author.id == AccountRepository.instance.id;
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
    if (content.isEmpty) throw const EmptyCommentException();

    if (content.containsBadWords) throw const ContainsBadWordsCommentException();

    try {
      final newComment = await _commentsRepository.createNewComment(
        feedType: 'tasted_record',
        id: id,
        content: content,
        parentId: _parentsId,
      );

      final parentId = _parentsId;

      if (parentId != null) {
        EventBus.instance.fire(
          CreateReCommentEvent(
            senderId: presenterId,
            parentId: parentId,
            objectId: id,
            newReComment: newComment,
            objectType: 'tasted_record',
          ),
        );
      } else {
        EventBus.instance.fire(
          CreateCommentEvent(
            senderId: presenterId,
            objectId: id,
            newComment: newComment,
            objectType: 'tasted_record',
          ),
        );
      }
      _replyUser = null;
      _parentsId = null;
      notifyListeners();
    } catch (_) {
      if (_parentsId != null) {
        throw const CommentCreateFailedException();
      } else {
        throw const ReCommentCreateFailedException();
      }
    }
  }

  String? roastingPointToString(int? roastingPoint) {
    if (roastingPoint == 1) {
      return '라이트';
    } else if (roastingPoint == 2) {
      return '라이트 미디엄';
    } else if (roastingPoint == 3) {
      return '미디엄';
    } else if (roastingPoint == 4) {
      return '미디엄 다크';
    } else if (roastingPoint == 5) {
      return '다크';
    } else {
      return null;
    }
  }
}
