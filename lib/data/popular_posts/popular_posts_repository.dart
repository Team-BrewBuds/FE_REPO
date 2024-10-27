import 'package:brew_buds/data/popular_posts/popular_posts_api.dart';
import 'package:brew_buds/model/pages/popular_post_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class PopularPostsRepository {
  final PopularPostsApi _api;
  PopularPostsRepository._(): _api = PopularPostsApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));

  static final PopularPostsRepository _instance = PopularPostsRepository._();

  static PopularPostsRepository get instance => _instance;

  factory PopularPostsRepository() => instance;

  Future<PopularPostsPage> fetchPopularPostsPage({
    required String subject,
    required int pageNo,
  }) => _api.fetchPopularPostsPage(subject: subject, format: 'json', pageNo: pageNo);
}