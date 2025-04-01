import 'dart:convert';

import 'package:brew_buds/data/api/feed_api.dart';
import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/recommendation_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/dto/post/post_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_feed_dto.dart';
import 'package:brew_buds/data/mapper/post/post_mapper.dart';
import 'package:brew_buds/data/mapper/recommended/recommended_page_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_feed_mapper.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';
import 'package:flutter/foundation.dart';

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
  final RecommendationApi _recommendationApi = RecommendationApi();
  final LikeApi _likeApi = LikeApi();
  final SaveApi _saveApi = SaveApi();
  final FollowApi _followApi = FollowApi();

  HomeRepository._();

  static final HomeRepository _instance = HomeRepository._();

  static HomeRepository get instance => _instance;

  factory HomeRepository() => instance;

  Future<DefaultPage<Feed>> fetchFeedPage({required FeedType feedType, required int pageNo}) async {
    final jsonString =
        await _feedApi.fetchFeedPage(feedType: feedType.toString(), pageNo: pageNo).onError((_, __) => '');

    if (jsonString.isNotEmpty) {
      return await compute<String, DefaultPage<Feed>>(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return DefaultPage<Feed>.fromJson(json, (jsonT) {
            final jsonMap = jsonT as Map<String, dynamic>;
            if (jsonMap.containsKey('tasted_records')) {
              return Feed.post(data: PostDTO.fromJson(jsonMap).toDomain());
            } else {
              return Feed.tastedRecord(data: TastedRecordInFeedDTO.fromJson(jsonMap).toDomain());
            }
          });
        },
        jsonString,
      );
    } else {
      return DefaultPage.initState();
    }

    return _feedApi.fetchFeedPage(feedType: feedType.toString(), pageNo: pageNo).then(
      (jsonString) {
        final json = jsonDecode(jsonString);
        return DefaultPage<Feed>.fromJson(json, (jsonT) {
          final jsonMap = jsonT as Map<String, dynamic>;
          if (jsonMap.containsKey('tasted_records')) {
            return Feed.post(data: PostDTO.fromJson(jsonMap).toDomain());
          } else {
            return Feed.tastedRecord(data: TastedRecordInFeedDTO.fromJson(jsonMap).toDomain());
          }
        });
      },
    );
  }

  Future<RecommendedPage> fetchRecommendedUserPage() async {
    final result = await _recommendationApi.fetchRecommendedBuddyPage();
    return compute((result) => result.toDomain(), result);
    return _recommendationApi.fetchRecommendedBuddyPage().then(
        (result) => result.toDomain(),
      );
  }

  Future<void> like({required String type, required int id, required bool isLiked}) {
    if (isLiked) {
      return _likeApi.unlike(type: type, id: id);
    } else {
      return _likeApi.like(type: type, id: id);
    }
  }

  Future<void> save({required String type, required int id, required bool isSaved}) {
    if (isSaved) {
      return _saveApi.unSave(type: type, id: id);
    } else {
      return _saveApi.save(type: type, id: id);
    }
  }

  Future<void> follow({required int id, required bool isFollow}) {
    if (isFollow) {
      return _followApi.unFollow(id: id);
    } else {
      return _followApi.follow(id: id);
    }
  }
}
