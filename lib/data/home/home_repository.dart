import 'package:brew_buds/data/home/home_api.dart';
import 'package:brew_buds/model/pages/feed_page.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum FeedType {
  following,
  common,
  random;

  @override
  String toString() => switch (this) {
        FeedType.following => 'following',
        FeedType.common => 'common',
        FeedType.random => 'refresh',
      };
}

final class HomeRepository {
  final HomeApi _api;

  HomeRepository._() : _api = HomeApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));

  static final HomeRepository _instance = HomeRepository._();

  static HomeRepository get instance => _instance;

  factory HomeRepository() => instance;

  Future<FeedPage> fetchFeedPage({
    required FeedType feedType,
    required int pageNo,
  }) => _api.fetchFeedPage(feedType: feedType.toString(), format: 'json', pageNo: pageNo);

  Future<PostFeedPage> fetchPostFeedPage({
    required String subjectFilter,
    required int pageNo,
  }) => _api.fetchPostFeedPage(subject: subjectFilter, format: 'json', pageNo: pageNo);

  Future<TastingRecordFeedPage> fetchTastingRecordFeedPage({
    required int pageNo,
  }) => _api.fetchTastingRecordFeedPage(format: 'json', pageNo: pageNo);

  Future<RecommendedUserPage> fetchRecommendedUserPage() => _api.fetchRecommendedUserPage();
}
