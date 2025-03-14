import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:flutter/foundation.dart';

typedef ProfileInfo = ({int? authorId, String nickName, String profileImageUrl, String createdAt, String viewCount});
typedef BodyInfo = ({
  List<String> imageUrlList,
  List<TastedRecordInPost> tastingRecords,
  String title,
  String contents,
  String tag,
  PostSubject subject,
});
typedef BottomButtonInfo = ({int likeCount, bool isLiked, int commentCount, bool isSaved});
typedef CommentsInfo = ({int? authorId, DefaultPage<Comment> page});

final class PostDetailPresenter extends ChangeNotifier {
  final PostRepository _postRepository = PostRepository.instance;
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  final int id;

  DefaultPage<Comment> _page = DefaultPage.initState();
  int _pageNo = 1;
  Post? _post;

  int? get authorId => _post?.author.id;

  ProfileInfo get profileInfo => (
        authorId: _post?.author.id,
        nickName: _post?.author.nickname ?? '',
        profileImageUrl: _post?.author.profileImageUrl ?? '',
        createdAt: _post?.createdAt ?? '',
        viewCount: '${_post?.viewCount ?? 0}',
      );

  BodyInfo get bodyInfo => (
        imageUrlList: _post?.imagesUrl ?? [],
        tastingRecords: _post?.tastingRecords ?? [],
        title: _post?.title ?? '',
        contents: _post?.contents ?? '',
        tag: _post?.tag ?? '',
        subject: _post?.subject ?? PostSubject.normal,
      );

  BottomButtonInfo get bottomButtonInfo => (
        likeCount: _post?.likeCount ?? 0,
        isLiked: _post?.isLiked ?? false,
        commentCount: _page.results.length,
        isSaved: _post?.isSaved ?? false,
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
    _pageNo = 1;
    _page = DefaultPage.initState();
    notifyListeners();
    await _fetchPost();
    await _fetchPost();
  }

  _fetchPost() async {
    _post = await _postRepository.fetchPost(id: id);
    notifyListeners();
  }

  fetchMorComments() async {
    if (!_page.hasNext) return;
    final newPage = await _commentsRepository.fetchCommentsPage(feedType: 'post', id: id, pageNo: _pageNo);
    _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext);
    _pageNo += 1;
    notifyListeners();
  }

  onTappedLikeButton() {
    final currentPost = _post;
    if (currentPost != null) {
      _postRepository.like(post: currentPost).then((value) {
        _fetchPost();
      });
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
    for (int pageNo = 1; pageNo <= _pageNo; pageNo++) {
      final newPage = await _commentsRepository.fetchCommentsPage(feedType: 'post', id: id, pageNo: pageNo);
      newComments.addAll(newPage.results);
    }
    _page = _page.copyWith(results: newComments);
    notifyListeners();
  }

  //isSave 구현 후 구현
  onTappedSaveButton() {
    final currentPost = _post;
    if (currentPost != null) {
      _postRepository.save(post: currentPost).then((value) {
        _fetchPost();
      });
    }
  }

  //댓글 기능 구현 필요
  createComment(String text) {}

  //댓글 기능 구현 필요
  createReComment(String text, Comment targetComment) {}
}
