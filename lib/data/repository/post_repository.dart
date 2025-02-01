import 'package:brew_buds/data/api/post_api.dart';
import '../../model/feeds/post_in_feed.dart';

class PostRepository {
  final PostApi _api;
  PostRepository._() : _api = PostApi();

  static final PostRepository _instance = PostRepository._();

  static PostRepository get instance => _instance;

  factory PostRepository() => _instance;

  Future createPost({
    required Map<String, dynamic> data,
  }) {
    // API 호출
    return _api.createPost(data: data);
  }
}