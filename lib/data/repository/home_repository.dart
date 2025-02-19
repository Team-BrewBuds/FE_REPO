import 'dart:convert';

import 'package:brew_buds/data/api/feed_api.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/api/recommendation_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:brew_buds/model/pages/recommended_users.dart';

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
  final FeedApi _feedApi = FeedApi();
  final PostApi _postApi = PostApi();
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final RecommendationApi _recommendationApi = RecommendationApi();
  final LikeApi _likeApi = LikeApi();
  final SaveApi _saveApi = SaveApi();
  final FollowApi _followApi = FollowApi();

  HomeRepository._();

  static final HomeRepository _instance = HomeRepository._();

  static HomeRepository get instance => _instance;

  factory HomeRepository() => instance;

  Future<DefaultPage<Feed>> fetchFeedPage({required FeedType feedType, required int pageNo}) =>
      _feedApi.fetchFeedPage(feedType: feedType.toString(), pageNo: pageNo).then(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return DefaultPage.fromJson(json, (jsonT) {
            final jsonMap = jsonT as Map<String, dynamic>;
            if (jsonMap.containsKey('tasted_records')) {
              return PostInFeed.fromJson(jsonMap);
            } else {
              return TastingRecordInFeed.fromJson(jsonMap);
            }
          });
        },
      );

  Future<DefaultPage<PostInFeed>> fetchPostFeedPage({required String? subjectFilter, required int pageNo}) =>
      _postApi.fetchPostFeedPage(subject: subjectFilter, pageNo: pageNo).then(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return DefaultPage.fromJson(json, (jsonT) {
            return PostInFeed.fromJson(jsonT as Map<String, dynamic>);
          });
        },
      );

  Future<DefaultPage<TastingRecordInFeed>> fetchTastingRecordFeedPage({required int pageNo}) =>
      _tastedRecordApi.fetchTastingRecordFeedPage(pageNo: pageNo).then(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return DefaultPage.fromJson(json, (jsonT) {
            return TastingRecordInFeed.fromJson(jsonT as Map<String, dynamic>);
          });
        },
      );

  Future<DefaultPage<RecommendedUsers>> fetchRecommendedUserPage() =>
      _recommendationApi.fetchRecommendedBuddyPage().then(
        (result) {
          return DefaultPage([result], true);
        },
      );

  Future<void> like({required String type, required int id}) => _likeApi.like(type: type, id: id);

  Future<void> unlike({required String type, required int id}) => _likeApi.unlike(type: type, id: id);

  Future<void> save({required String type, required int id}) => _saveApi.save(type: type, id: id);

  Future<void> delete({required String type, required int id}) => _saveApi.unSave(type: type, id: id);

  Future<void> follow({required int id}) => _followApi.follow(id: id);

  Future<void> unFollow({required int id}) => _followApi.unFollow(id: id);
}
