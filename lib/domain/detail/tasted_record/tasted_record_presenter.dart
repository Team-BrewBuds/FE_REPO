import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:flutter/foundation.dart';

typedef BottomButtonInfo = ({int likeCount, bool isLiked, bool isSaved});
typedef ProfileInfo = ({String nickName, int? authorId, String profileImageUrl, bool isFollow, bool isMine});
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
typedef CommentsInfo = ({int? authorId, DefaultPage<Comment> page});
typedef CommentTextFieldState = ({String? prentCommentAuthorNickname, String authorNickname});

final class TastedRecordPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  final BlockApi _blockApi = BlockApi();
  final int id;
  bool _isEmpty = false;
  Comment? _parentComment;
  TastedRecord? _tastedRecord;
  DefaultPage<Comment> _page = DefaultPage.initState();
  int _pageNo = 1;

  bool get isEmpty => _isEmpty;

  TastedRecord? get tastedRecord => _tastedRecord;

  bool get isMine => AccountRepository.instance.id == _tastedRecord?.author.id;

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
        isMine: isMine,
      );

  ContentsInfo get contentsInfo => (
        rating: _tastedRecord?.tastingReview.star ?? 0,
        flavors: _tastedRecord?.tastingReview.flavors ?? [],
        tastedAt: _tastedRecord?.createdAt ?? '',
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

  CommentsInfo get commentsInfo => (authorId: _tastedRecord?.author.id, page: _page);

  CommentTextFieldState get commentTextFieldState => (
        prentCommentAuthorNickname: _parentComment?.author.nickname,
        authorNickname: _tastedRecord?.author.nickname ?? '',
      );

  TastedRecordPresenter({
    required this.id,
  });

  init() async {
    _page = DefaultPage.initState();
    _pageNo = 1;
    notifyListeners();
    _fetchTastedRecord();
    fetchMoreComments();
  }

  onRefresh() async {
    _page = DefaultPage.initState();
    _pageNo = 1;
    notifyListeners();
    _fetchTastedRecord();
    fetchMoreComments();
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

  fetchMoreComments() async {
    if (!_page.hasNext) return;
    final newPage = await _commentsRepository.fetchCommentsPage(feedType: 'tasted_record', id: id, pageNo: _pageNo);
    _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext, count: newPage.count);
    _pageNo += 1;
    notifyListeners();
  }

  Future<Result<String>> onDelete() {
    return _tastedRecordRepository
        .delete(id: id)
        .then((value) => Result.success('게시글 삭제를 완료했어요.'))
        .onError((error, stackTrace) => Result.error('게시글 삭제에 실패했어요.'));
  }

  Future<Result<String>> onBlock() {
    final authorId = _tastedRecord?.author.id;
    if (authorId != null) {
      return _blockApi
          .block(id: authorId)
          .then((value) => Result.success('차단을 완료했어요.'))
          .onError((error, stackTrace) => Result.error('차단에 실패했어요.'));
    } else {
      return Future.value(Result.error('차단에 실패했어요.'));
    }
  }

  onTappedFollowButton() {
    final currentTastingRecord = _tastedRecord;
    if (currentTastingRecord != null) {
      _tastedRecordRepository
          .follow(id: currentTastingRecord.id, isFollow: currentTastingRecord.isAuthorFollowing)
          .then((value) => _fetchTastedRecord());
    }
  }

  onTappedLikeButton() {
    final currentTastingRecord = _tastedRecord;
    if (currentTastingRecord != null) {
      _tastedRecordRepository
          .like(id: currentTastingRecord.id, isLiked: currentTastingRecord.isLiked)
          .then((value) => _fetchTastedRecord());
    }
  }

  onTappedCommentLikeButton(Comment targetComment, {Comment? parentComment}) {
    if (targetComment.isLiked) {
      _commentsRepository.likeComment(id: targetComment.id).then((_) {
        reloadComments();
      });
    } else {
      _commentsRepository.unLikeComment(id: targetComment.id).then((_) {
        reloadComments();
      });
    }
  }

  onTappedDeleteCommentButton(Comment comment) {
    _commentsRepository.deleteComment(id: comment.id).then((_) => reloadComments());
  }

  bool canDeleteComment({required int authorId}) {
    return authorId == AccountRepository.instance.id || isMine;
  }

  reloadComments() async {
    final List<Comment> newComments = [];
    for (int pageNo = 1; pageNo < _pageNo; pageNo++) {
      final newPage = await _commentsRepository.fetchCommentsPage(feedType: 'tasted_record', id: id, pageNo: pageNo);
      newComments.addAll(newPage.results);
    }
    _page = _page.copyWith(results: newComments);
    notifyListeners();
  }

  onTappedSaveButton() {
    final currentTastingRecord = _tastedRecord;
    if (currentTastingRecord != null) {
      _tastedRecordRepository
          .save(id: currentTastingRecord.id, isSaved: currentTastingRecord.isSaved)
          .then((value) => _fetchTastedRecord());
    }
  }

  Future<void> createComment(String text) {
    final parentComment = _parentComment;
    if (parentComment != null) {
      return _commentsRepository
          .createNewComment(feedType: 'tasted_record', id: id, content: text, parentId: parentComment.id)
          .then((_) {
        _parentComment = null;
        reloadComments();
      });
    } else {
      return _commentsRepository.createNewComment(feedType: 'tasted_record', id: id, content: text).then((_) {
        reloadComments();
      });
    }
  }

  bool isMineComment(Comment comment) {
    return comment.author.id == AccountRepository.instance.id;
  }

  onTappedReply(Comment comment) {
    _parentComment = comment;
    notifyListeners();
  }

  cancelReply() {
    _parentComment = null;
    notifyListeners();
  }

  String? roastingPointToString(int? roastingPoint) {
    if (roastingPoint == 1) {
      return '라이트';
    } else if (roastingPoint == 2) {
      return '라이트 미디엄';
    } else if (roastingPoint == 3) {
      return '미디';
    } else if (roastingPoint == 4) {
      return '미디엄 다크';
    } else if (roastingPoint == 5) {
      return '다크';
    } else {
      return null;
    }
  }
}
