import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';

class PopularPostsRepository {
  final PostApi _api = PostApi();
  PopularPostsRepository._();

  static final PopularPostsRepository _instance = PopularPostsRepository._();

  static PopularPostsRepository get instance => _instance;

  factory PopularPostsRepository() => instance;

  Future<PopularPostsPage> fetchPopularPostsPage({
    required String subject,
    required int pageNo,
  }) => _api.fetchPopularPostsPage(subject: subject, pageNo: pageNo);
}