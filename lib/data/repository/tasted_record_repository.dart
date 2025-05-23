import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/local_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/data/dto/common/local_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_feed_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_profile_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/common/local_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/taste_review_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_feed_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_profile_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_mapper.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/local.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:flutter/foundation.dart';

class TastedRecordRepository {
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final LocalApi _localApi = LocalApi();
  final LikeApi _likeApi = LikeApi();
  final SaveApi _saveApi = SaveApi();
  final FollowApi _followApi = FollowApi();

  TastedRecordRepository._();

  static final TastedRecordRepository _instance = TastedRecordRepository._();

  static TastedRecordRepository get instance => _instance;

  factory TastedRecordRepository() => instance;

  Future<DefaultPage<Feed>> fetchTastedRecordFeedPage({required int pageNo}) async {
    final jsonString = await _tastedRecordApi.fetchTastingRecordFeedPage(pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => Feed.tastedRecord(
              data: TastedRecordInFeedDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
            ),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<TastedRecord> fetchTastedRecord({required int id}) async {
    final jsonString = await _tastedRecordApi.fetchTastedRecord(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return TastedRecordDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<TastedRecordInProfile>> fetchTastedRecordPage({
    required int userId,
    required int pageNo,
    String? orderBy,
    String? beanType,
    bool? isDecaf,
    String? country,
    double? roastingPointMin,
    double? roastingPointMax,
    double? ratingMin,
    double? ratingMax,
  }) async {
    final jsonString = await _tastedRecordApi.fetchTastedRecordPage(
      userId: userId,
      pageNo: pageNo,
      orderBy: orderBy,
      beanType: beanType,
      isDecaf: isDecaf,
      country: country,
      roastingPointMin: roastingPointMin,
      roastingPointMax: roastingPointMax,
      ratingMin: ratingMin,
      ratingMax: ratingMax,
    );
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => TastedRecordInProfileDTO.fromJson(jsonT as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<DefaultPage<Local>> fetchLocal({required String word, required int pageNo, String? x, String? y}) async {
    final jsonString = await _localApi.fetchLocal(query: word, x: x, y: y, pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final count = json['meta']['total_count'] as int?;
          final hasNext = !json['meta']['is_end'] as bool?;
          final resultJson = json['documents'] as List<dynamic>?;
          return DefaultPage(
            count: count ?? 0,
            results: resultJson?.map((e) => LocalDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList() ?? [],
            hasNext: hasNext ?? false,
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<void> like({required int id, required bool isLiked}) {
    if (isLiked) {
      return _likeApi.unlike(type: 'tasted_record', id: id);
    } else {
      return _likeApi.like(type: 'tasted_record', id: id);
    }
  }

  Future<void> delete({required int id}) {
    return _tastedRecordApi.deleteTastedRecord(id: id);
  }

  Future<void> save({required int id, required bool isSaved}) {
    if (isSaved) {
      return _saveApi.unSave(type: 'tasted_record', id: id);
    } else {
      return _saveApi.save(type: 'tasted_record', id: id);
    }
  }

  Future<void> follow({required int id, required bool isFollow}) {
    if (isFollow) {
      return _followApi.unFollow(id: id);
    } else {
      return _followApi.follow(id: id);
    }
  }

  Future<void> create({
    required String content,
    required bool isPrivate,
    required String tag,
    required CoffeeBean coffeeBean,
    required TasteReview tasteReview,
    List<int> photos = const [],
  }) {
    final Map<String, dynamic> data = {};
    data['content'] = content;
    if (tag.isNotEmpty) {
      data['tag'] = tag;
    }
    data['is_private'] = isPrivate;
    data['bean'] = coffeeBean.toJson();
    data['taste_review'] = tasteReview.toJson();
    if (photos.isNotEmpty) {
      data['photos'] = photos;
    }

    return _tastedRecordApi.createTastedRecord(data: data);
  }

  Future<TastedRecord> update({required int id, required Map<String, dynamic> data}) => _tastedRecordApi
      .updateTastedRecord(
        id: id,
        data: data,
      )
      .then((dto) => dto.toDomain());
}
