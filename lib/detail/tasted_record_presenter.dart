import 'package:brew_buds/data/api/comment_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/detail/model/tasting_record.dart';
import 'package:brew_buds/detail/model/tasting_review.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:flutter/foundation.dart';

typedef BottomButtonInfo = ({int likeCount, bool isLiked, int commentCount, bool isSaved});
typedef ProfileInfo = ({String nickName, int? authorId, String profileImageUri, bool isFollow});
typedef ContentsInfo = ({double rating, List<String> flavors, String tastedAt, String contents, String location});
typedef BeanInfo = ({
  String? beanType,
  bool? isDecaf,
  List<String> country,
  String? region,
  String? process,
  String? roastingPoint,
});
typedef CommentsInfo = ({int? authorId, CommentsPage? page});

final class TastedRecordPresenter extends ChangeNotifier {
  final int id;
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final LikeApi _likeApi = LikeApi();
  final CommentApi _commentApi = CommentApi();

  TastingRecord? _tastingRecord;
  CommentsPage? _page;

  bool get isMine => AccountRepository.instance.id == _tastingRecord?.author.id;

  List<String> get imageUriList => _tastingRecord?.imagesUri ?? [];

  BottomButtonInfo get bottomButtonInfo => (
        likeCount: _tastingRecord?.likeCount ?? 0,
        isLiked: _tastingRecord?.isLiked ?? false,
        commentCount: _page?.comments.length ?? 0,
        isSaved: true,
      );

  String get title => _tastingRecord?.bean.name ?? '';

  ProfileInfo get profileInfo => (
        nickName: _tastingRecord?.author.nickname ?? '',
        authorId: _tastingRecord?.author.id,
        profileImageUri: _tastingRecord?.author.profileImageUri ?? '',
        isFollow: false,
      );

  ContentsInfo get contentsInfo => (
        rating: _tastingRecord?.tastingReview.star ?? 0,
        flavors: _tastingRecord?.tastingReview.flavors ?? [],
        tastedAt: _tastingRecord?.createdAt ?? '',
        contents: _tastingRecord?.contents ?? '',
        location: _tastingRecord?.tastingReview.place ?? '',
      );

  TastingReview? get tastingReview => _tastingRecord?.tastingReview;

  BeanInfo get beanInfo => (
        beanType: _tastingRecord?.bean.type.toString(),
        isDecaf: _tastingRecord?.bean.isDecaf,
        country: _tastingRecord?.bean.country.map((country) => country.toString()).toList() ?? [],
        region: _tastingRecord?.bean.region,
        process: _tastingRecord?.bean.process,
        roastingPoint: roastingPointToString(_tastingRecord?.bean.roastPoint),
      );

  CommentsInfo get commentsInfo => (authorId: _tastingRecord?.author.id, page: _page);

  TastedRecordPresenter({
    required this.id,
  });

  init() async {
    _tastingRecord = await _tastedRecordApi.fetchTastedRecord(id: id);
    _page = await _commentApi.fetchCommentsPage(feedType: 'tasted_record', id: id, pageNo: 1);
    notifyListeners();
  }

  onTappedLikeButton() {
    final currentTastingRecord = _tastingRecord;
    if (currentTastingRecord != null) {
      if (currentTastingRecord.isLiked) {
        _likeApi.unlike(type: 'tasted_record', id: id).then((_) {
          _tastingRecord = currentTastingRecord.copyWith(isLiked: false, likeCount: currentTastingRecord.likeCount - 1);
          notifyListeners();
        });
      } else {
        _likeApi.like(type: 'tasted_record', id: id).then((_) {
          _tastingRecord = currentTastingRecord.copyWith(isLiked: true, likeCount: currentTastingRecord.likeCount + 1);
          notifyListeners();
        });
      }
    }
  }

  onTappedCommentLikeButton(Comment targetComment, {Comment? parentComment}) {
    final currentCommentsPage = _page;
    if (currentCommentsPage != null) {
      if (targetComment.isLiked) {
        _likeApi.unlike(type: 'comment', id: targetComment.id).then((_) {
          if (parentComment != null) {
            _page = currentCommentsPage.copyWith(
                comments: currentCommentsPage.comments.map((comment) {
                  if (comment.id == parentComment.id) {
                    return parentComment.copyWith(
                        reComments: parentComment.reComments.map((reComment) {
                          if (reComment.id == targetComment.id) {
                            return targetComment.copyWith(isLiked: false, likeCount: targetComment.likeCount - 1);
                          } else {
                            return reComment;
                          }
                        }).toList());
                  } else {
                    return comment;
                  }
                }).toList());
          } else {
            _page = currentCommentsPage.copyWith(
                comments: currentCommentsPage.comments.map((comment) {
                  if (comment.id == targetComment.id) {
                    return targetComment.copyWith(isLiked: false, likeCount: targetComment.likeCount - 1);
                  } else {
                    return comment;
                  }
                }).toList());
          }
          notifyListeners();
        });
      } else {
        _likeApi.like(type: 'comment', id: targetComment.id).then((_) {
          if (parentComment != null) {
            _page = currentCommentsPage.copyWith(
                comments: currentCommentsPage.comments.map((comment) {
                  if (comment.id == parentComment.id) {
                    return parentComment.copyWith(
                        reComments: parentComment.reComments.map((reComment) {
                          if (reComment.id == targetComment.id) {
                            return targetComment.copyWith(isLiked: true, likeCount: targetComment.likeCount + 1);
                          } else {
                            return reComment;
                          }
                        }).toList());
                  } else {
                    return comment;
                  }
                }).toList());
          } else {
            _page = currentCommentsPage.copyWith(
                comments: currentCommentsPage.comments.map((comment) {
                  if (comment.id == targetComment.id) {
                    return targetComment.copyWith(isLiked: true, likeCount: targetComment.likeCount + 1);
                  } else {
                    return comment;
                  }
                }).toList());
          }
          notifyListeners();
        });
      }
    }
  }

  onTappedDeleteCommentButton(Comment targetComment) {
    _commentApi.deleteComment(id: targetComment.id).then((_) => _reloadComments());
  }

  bool canDeleteComment({required int authorId}) {
    return authorId == AccountRepository.instance.id || isMine;
  }

  _reloadComments() async {
    _page = await _commentApi.fetchCommentsPage(feedType: 'tasted_record', id: id, pageNo: 1);
    notifyListeners();
  }

  //isSave 구현 후 구현
  onTappedSaveButton() {}

  //댓글 기능 구현 필요
  createComment(String text) {}

  //댓글 기능 구현 필요
  createReComment(String text, Comment targetComment) {}

  String? roastingPointToString(double? roastingPoint) {
    if (roastingPoint == 1.0) {
      return '라이트';
    } else if (roastingPoint == 2.0) {
      return '라이트 미디엄';
    } else if (roastingPoint == 3.0) {
      return '미디';
    } else if (roastingPoint == 4.0) {
      return '미디엄 다크';
    } else if (roastingPoint == 5.0) {
      return '다크';
    } else {
      return null;
    }
  }
}
