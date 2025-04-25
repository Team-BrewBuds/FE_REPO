import 'package:brew_buds/core/event_bus.dart';
import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/core/result.dart';
import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/comments_repository.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/events/comment_event.dart';
import 'package:brew_buds/model/events/post_event.dart';
import 'package:brew_buds/model/events/user_follow_event.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';

typedef ProfileInfo = ({
  int? authorId,
  String nickName,
  String profileImageUrl,
  String createdAt,
  String viewCount,
  bool isFollow,
});
typedef BodyInfo = ({
  List<String> imageUrlList,
  List<TastedRecordInPost> tastingRecords,
  String title,
  String contents,
  String tag,
  PostSubject subject,
});
typedef BottomButtonInfo = ({int likeCount, bool isLiked, bool isSaved});
typedef CommentsInfo = ({int? authorId, DefaultPage<Comment> page});
typedef CommentTextFieldState = ({String? prentCommentAuthorNickname, String authorNickname});

final class PostDetailPresenter extends Presenter {
  final PostRepository _postRepository = PostRepository.instance;
  final CommentsRepository _commentsRepository = CommentsRepository.instance;
  final BlockApi _blockApi = BlockApi();
  final int id;
  bool _isEmpty = false;
  Post? _post;
  User? _replyUser;
  int? _parentsId;

  bool get isEmpty => _isEmpty;

  Post? get post => _post;

  int? get authorId => _post?.author.id;

  String? get authorNickname => _post?.author.nickname;

  ProfileInfo get profileInfo => (
        authorId: _post?.author.id,
        nickName: _post?.author.nickname ?? '',
        profileImageUrl: _post?.author.profileImageUrl ?? '',
        createdAt: _post?.createdAt ?? '',
        viewCount: '${_post?.viewCount ?? 0}',
        isFollow: _post?.isAuthorFollowing ?? false,
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
        isSaved: _post?.isSaved ?? false,
      );

  CommentTextFieldState get commentTextFieldState => (
        prentCommentAuthorNickname: _replyUser?.nickname,
        authorNickname: _post?.author.nickname ?? '',
      );

  PostDetailPresenter({
    required this.id,
  }) {
    _fetchPost();
  }

  Future<void> onRefresh() async {
    await _fetchPost();
  }

  _fetchPost() async {
    try {
      _post = await _postRepository.fetchPost(id: id);
    } catch (e) {
      _isEmpty = true;
    } finally {
      notifyListeners();
    }
  }

  Future<void> onDelete() => _postRepository.delete(id: id);

  Future<Result<String>> onBlock() {
    final authorId = _post?.author.id;
    if (authorId != null) {
      return _blockApi
          .block(id: authorId)
          .then((value) => Result.success('차단을 완료했어요.'))
          .onError((error, stackTrace) => Result.error('차단에 실패했어요.'));
    } else {
      return Future.value(Result.error('차단에 실패했어요.'));
    }
  }

  onTappedFollowButton() async {
    final currentPost = _post;
    if (currentPost != null) {
      final isFollow = currentPost.isAuthorFollowing;
      _post = currentPost.copyWith(isAuthorFollowing: !isFollow);
      notifyListeners();

      try {
        await _postRepository.follow(post: currentPost);
        EventBus.instance.fire(
          UserFollowEvent(
            senderId: presenterId,
            userId: currentPost.author.id,
            isFollow: !isFollow,
          ),
        );
      } catch (e) {
        _post = currentPost.copyWith(isAuthorFollowing: isFollow);
        notifyListeners();
      }
    }
  }

  onTappedLikeButton() async {
    final currentPost = _post;
    if (currentPost != null) {
      final isLiked = currentPost.isLiked;
      final likeCount = currentPost.likeCount;
      _post = currentPost.copyWith(
        isLiked: !isLiked,
        likeCount: isLiked ? likeCount - 1 : likeCount + 1,
      );
      notifyListeners();

      try {
        await _postRepository.like(post: currentPost);
        EventBus.instance.fire(
          PostLikeEvent(
            senderId: presenterId,
            id: id,
            isLiked: !isLiked,
            likeCount: isLiked ? likeCount - 1 : likeCount + 1,
          ),
        );
      } catch (e) {
        _post = currentPost.copyWith(isLiked: isLiked, likeCount: likeCount);
        notifyListeners();
      }
    }
  }

  onTappedSaveButton() async {
    final currentPost = _post;
    if (currentPost != null) {
      final isSaved = currentPost.isSaved;
      _post = currentPost.copyWith(isSaved: !isSaved);
      notifyListeners();

      try {
        await _postRepository.save(post: currentPost);
        EventBus.instance.fire(
          PostSaveEvent(
            senderId: presenterId,
            id: id,
            isSaved: !isSaved,
          ),
        );
      } catch (e) {
        _post = currentPost.copyWith(isSaved: isSaved);
        notifyListeners();
      }
    }
  }

  bool isWriter(int authorId) {
    return authorId == _post?.author.id;
  }

  bool isMine(int authorId) {
    return authorId == AccountRepository.instance.id;
  }

  bool isMyObject() {
    return _post?.author.id == AccountRepository.instance.id;
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
        feedType: 'post',
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
            objectType: 'post',
          ),
        );
      } else {
        EventBus.instance.fire(
          CreateCommentEvent(
            senderId: presenterId,
            objectId: id,
            newComment: newComment,
            objectType: 'post',
          ),
        );
      }
      _replyUser = null;
      notifyListeners();
    } catch (_) {
      rethrow;
    }
  }
}
