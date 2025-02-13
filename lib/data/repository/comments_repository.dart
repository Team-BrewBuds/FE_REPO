import 'package:brew_buds/data/api/comment_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/pages/comments_page.dart';

class CommentsRepository {
  final LikeApi _likeApi;
  final CommentApi _api;

  CommentsRepository._() : _api = CommentApi(), _likeApi = LikeApi();

  static final CommentsRepository _instance = CommentsRepository._();

  static CommentsRepository get instance => _instance;

  factory CommentsRepository() => instance;

  Future<CommentsPage> fetchCommentsPage({
    required String feedType,
    required int id,
    required int pageNo,
  }) =>
      _api.fetchCommentsPage(feedType: feedType, id: id, pageNo: pageNo);

  Future<Comment> createNewComment({
    required String feedType,
    required int id,
    required String content,
    int? parentId,
  }) =>
      _api.createComment(
        feedType: feedType,
        id: id,
        data: parentId == null
            ? <String, dynamic>{"content": content}
            : <String, dynamic>{"content": content, "parent": parentId},
      );
  
  Future<void> deleteComment({required int id}) => _api.deleteComment(id: id);
  
  Future<void> likeComment({required int id}) => _likeApi.like(type: 'comment', id: id);

  Future<void> unLikeComment({required int id}) => _likeApi.unlike(type: 'comment', id: id);
}
