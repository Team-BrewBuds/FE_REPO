import 'package:brew_buds/data/api/comment_api.dart';
import 'package:brew_buds/model/pages/comments_page.dart';

class CommentsRepository {
  final CommentApi _api;

  CommentsRepository._() : _api = CommentApi();

  static final CommentsRepository _instance = CommentsRepository._();

  static CommentsRepository get instance => _instance;

  factory CommentsRepository() => instance;

  Future<CommentsPage> fetchCommentsPage({
    required String feedType,
    required int id,
    required int pageNo,
  }) => _api.fetchCommentsPage(feedType: feedType, id: id, pageNo: pageNo);
}
