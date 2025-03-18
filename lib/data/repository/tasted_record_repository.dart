import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_feed_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/taste_review_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_in_feed_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/tasted_record_mapper.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';

class TastedRecordRepository {
  final TastedRecordApi _tastedRecordApi = TastedRecordApi();
  final LikeApi _likeApi = LikeApi();
  final SaveApi _saveApi = SaveApi();
  final FollowApi _followApi = FollowApi();

  TastedRecordRepository._();

  static final TastedRecordRepository _instance = TastedRecordRepository._();

  static TastedRecordRepository get instance => _instance;

  factory TastedRecordRepository() => instance;

  Future<DefaultPage<TastedRecordInFeed>> fetchTastedRecordFeedPage({required int pageNo}) =>
      _tastedRecordApi.fetchTastingRecordFeedPage(pageNo: pageNo).then(
        (jsonString) {
          final json = jsonDecode(jsonString);
          return DefaultPage.fromJson(
            json,
            (jsonT) {
              return TastedRecordInFeedDTO.fromJson(jsonT as Map<String, dynamic>).toDomain();
            },
          );
        },
      );

  Future<TastedRecord> fetchTastedRecord({required int id}) =>
      _tastedRecordApi.fetchTastedRecord(id: id).then((value) => value.toDomain());

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
    data['isprivate'] = isPrivate;
    data['bean'] = coffeeBean.toJson();
    data['taste_review'] = tasteReview.toJson();
    if (photos.isNotEmpty) {
      data['photos'] = photos;
    }

    return _tastedRecordApi.createTastedRecord(data: data);
  }
}
