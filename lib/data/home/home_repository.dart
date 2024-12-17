import 'package:brew_buds/data/home/home_api.dart';
import 'package:brew_buds/model/pages/feed_page.dart';
import 'package:brew_buds/model/pages/post_feed_page.dart';
import 'package:brew_buds/model/pages/recommended_user_page.dart';
import 'package:brew_buds/model/pages/tasting_record_feed_page.dart';

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
  final HomeApi _api = HomeApi.defaultApi();

  HomeRepository._();

  static final HomeRepository _instance = HomeRepository._();

  static HomeRepository get instance => _instance;

  factory HomeRepository() => instance;

  Future<FeedPage> fetchFeedPage({
    required FeedType feedType,
    required int pageNo,
  }) =>
      _api.fetchFeedPage(feedType: feedType.toString(), pageNo: pageNo);

  Future<PostFeedPage> fetchPostFeedPage({
    required String? subjectFilter,
    required int pageNo,
  }) =>
      _api.fetchPostFeedPage(subject: subjectFilter, pageNo: pageNo);

  Future<TastingRecordFeedPage> fetchTastingRecordFeedPage({
    required int pageNo,
  }) =>
      _api.fetchTastingRecordFeedPage(pageNo: pageNo);

  Future<RecommendedUserPage> fetchRecommendedUserPage() => _api.fetchRecommendedUserPage();

  Future<void> like({required String type, required int id}) => _api.like(type: type, id: id);

  Future<void> unlike({required String type, required int id}) => _api.unlike(type: type, id: id);
}
