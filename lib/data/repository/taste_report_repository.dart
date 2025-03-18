import 'dart:convert';
import 'package:brew_buds/data/api/taste_report_api.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_in_calendar_dto.dart';
import 'package:brew_buds/data/dto/common/top_flavor_dto.dart';
import 'package:brew_buds/data/dto/post/post_in_calendar_dto.dart';
import 'package:brew_buds/data/dto/taste_report/top_origin_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_calendar_dto.dart';
import 'package:brew_buds/data/mapper/common/top_flavor_mapper.dart';
import 'package:brew_buds/data/mapper/taste_report/activity_item_mapper.dart';
import 'package:brew_buds/data/mapper/taste_report/activity_summary_mapper.dart';
import 'package:brew_buds/data/mapper/taste_report/rating_distribution_mapper.dart';
import 'package:brew_buds/data/mapper/taste_report/top_country_mapper.dart';
import 'package:brew_buds/model/common/top_flavor.dart';
import 'package:brew_buds/model/taste_report/activity_item.dart';
import 'package:brew_buds/model/taste_report/activity_summary.dart';
import 'package:brew_buds/model/taste_report/rating_distribution.dart';
import 'package:brew_buds/model/taste_report/top_country.dart';

class TasteReportRepository {
  final TasteReportApi _reportApi = TasteReportApi();

  TasteReportRepository._();

  static final TasteReportRepository _instance = TasteReportRepository._();

  static TasteReportRepository get instance => _instance;

  factory TasteReportRepository() => instance;

  Future<ActivitySummary> fetchActivitySummary({
    required int id,
  }) =>
      _reportApi.fetchActivitySummary(id: id).then((value) => value.toDomain());

  Future<Map<String, List<ActivityItem>>> fetchPostActivityCalendar({
    required int id,
    int? year,
    int? month,
  }) {
    return _reportApi.fetchActivityCalendar(id: id, year: year, month: month, type: 'post').then((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final activityItem = json['post'] as Map<String, dynamic>;
      return activityItem.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => PostInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain())
              .toList(),
        ),
      );
    });
  }

  Future<Map<String, List<ActivityItem>>> fetchTastedRecordActivityCalendar({
    required int id,
    int? year,
    int? month,
  }) {
    return _reportApi.fetchActivityCalendar(id: id, year: year, month: month, type: 'tasted_record').then((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final activityItem = json['tasted_record'] as Map<String, dynamic>;
      return activityItem.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => TastedRecordInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain())
              .toList(),
        ),
      );
    });
  }

  Future<Map<String, List<ActivityItem>>> fetchSavedBeanActivityCalendar({
    required int id,
    int? year,
    int? month,
  }) {
    return _reportApi.fetchActivityCalendar(id: id, year: year, month: month, type: 'saved_bean').then((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final activityItem = json['saved_bean'] as Map<String, dynamic>;
      return activityItem.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => CoffeeBeanInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain())
              .toList(),
        ),
      );
    });
  }

  Future<Map<String, List<ActivityItem>>> fetchSavedNoteActivityCalendar({
    required int id,
    int? year,
    int? month,
  }) {
    return _reportApi.fetchActivityCalendar(id: id, year: year, month: month, type: 'saved_note').then((jsonString) {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      final postItem = json['saved_note']['post'] as Map<String, dynamic>? ?? {};
      final tastedRecordItem = json['saved_note']['tasted_record'] as Map<String, dynamic>? ?? {};
      final activityItem = postItem.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>)
              .map((e) => PostInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain())
              .toList(),
        ),
      );
      tastedRecordItem.forEach((key, value) {
        if (activityItem.containsKey(key)) {
          (activityItem[key] ?? []).addAll(
              (value as List<dynamic>).map((e) => TastedRecordInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain()));
        } else {
          activityItem[key] = (value as List<dynamic>)
              .map((e) => TastedRecordInCalendarDTO.fromJson(e as Map<String, dynamic>).toDomain())
              .toList();
        }
      });
      return activityItem;
    });
  }

  Future<RatingDistribution> fetchRatingDistribution({
    required int id,
  }) =>
      _reportApi.fetchRatingDistribution(id: id).then((value) => value.toDomain());

  Future<List<TopFlavor>> fetchFavoriteFlavor({
    required int id,
  }) =>
      _reportApi.fetchFavoriteFlavor(id: id).then(
        (jsonString) {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final flavorsJson = json['top_flavors'] as List<dynamic>? ?? [];
          return flavorsJson.map((e) => TopFlavorDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList()
            ..sort((a, b) => b.percent.compareTo(a.percent));
        },
      );

  Future<List<TopCountry>> fetchPreferredCountry({
    required int id,
  }) =>
      _reportApi.fetchPreferredCountry(id: id).then(
        (jsonString) {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          final originsJson = json['top_origins'] as List<dynamic>? ?? [];
          return originsJson.map((e) => TopOriginDTO.fromJson(e as Map<String, dynamic>).toDomain()).toList()
            ..sort((a, b) => b.percent.compareTo(a.percent));
        },
      );
}
