import 'package:brew_buds/data/api/comment_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/detail/model/post.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/pages/comments_page.dart';
import 'package:brew_buds/model/post_subject.dart';
import 'package:brew_buds/model/tasting_record_in_post.dart';
import 'package:flutter/foundation.dart';

typedef ProfileInfo = ({int? authorId, String nickName, String profileImageUri, String createdAt, String viewCount});
typedef BodyInfo = ({
  List<String> imageUriList,
  List<TastingRecordInPost> tastingRecords,
  String title,
  String contents,
  String tag,
  PostSubject subject,
});
typedef BottomButtonInfo = ({int likeCount, bool isLiked, int commentCount, bool isSaved});
typedef CommentsInfo = ({int? authorId, CommentsPage? page});

final class PostDetailPresenter extends ChangeNotifier {
  final int id;
  final PostApi _postApi = PostApi();
  final LikeApi _likeApi = LikeApi();
  final CommentApi _commentApi = CommentApi();

  Post? _post;
  CommentsPage? _page;

  int? get authorId => _post?.author.id;

  ProfileInfo get profileInfo => (
        authorId: _post?.author.id,
        nickName: _post?.author.nickname ?? '',
        profileImageUri: _post?.author.profileImageUri ?? '',
        createdAt: _post?.createdAt ?? '',
        viewCount: '${_post?.viewCount ?? 0}',
      );

  BodyInfo get bodyInfo => (
        imageUriList: _post?.imagesUri ?? [],
        tastingRecords: _post?.tastingRecords ?? [],
        title: _post?.title ?? '',
        contents: _post?.contents ?? '',
        tag: _post?.tag ?? '',
        subject: _post?.subject ?? PostSubject.normal,
      );

  BottomButtonInfo get bottomButtonInfo => (
        likeCount: _post?.likeCount ?? 0,
        isLiked: _post?.isLiked ?? false,
        commentCount: _page?.comments.length ?? 0,
        isSaved: true,
      );

  CommentsInfo get commentsInfo => (
        authorId: _post?.author.id,
        page: _page,
      );

  bool get isMine => AccountRepository.instance.id == _post?.author.id;

  PostDetailPresenter({
    required this.id,
  });

  init() async {
    _post = await _postApi.fetchPost(id: id);
    _page = await _commentApi.fetchCommentsPage(feedType: 'post', id: id, pageNo: 1);
    notifyListeners();
  }

  onTappedLikeButton() {
    final currentPost = _post;
    if (currentPost != null) {
      if (currentPost.isLiked) {
        _likeApi.unlike(type: 'post', id: id).then((_) {
          _post = _post?.copyWith(isLiked: false, likeCount: currentPost.likeCount - 1);
          notifyListeners();
        });
      } else {
        _likeApi.like(type: 'post', id: id).then((_) {
          _post = _post?.copyWith(isLiked: true, likeCount: currentPost.likeCount + 1);
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
    _page = await _commentApi.fetchCommentsPage(feedType: 'post', id: id, pageNo: 1);
    notifyListeners();
  }

  //isSave 구현 후 구현
  onTappedSaveButton() {}

  //댓글 기능 구현 필요
  createComment(String text) {}

  //댓글 기능 구현 필요
  createReComment(String text, Comment targetComment) {}
}
