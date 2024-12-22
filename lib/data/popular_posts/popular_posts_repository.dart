import 'package:brew_buds/data/popular_posts/popular_posts_api.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';

class PopularPostsRepository {
  final PopularPostsApi _api;
  PopularPostsRepository._(): _api = PopularPostsApi();

  static final PopularPostsRepository _instance = PopularPostsRepository._();

  static PopularPostsRepository get instance => _instance;

  factory PopularPostsRepository() => instance;

  Future<PopularPostsPage> fetchPopularPostsPage({
    required String subject,
    required int pageNo,
  }) => _api.fetchPopularPostsPage(subject: subject, pageNo: pageNo);
}