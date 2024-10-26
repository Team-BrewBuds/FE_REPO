import 'package:brew_buds/model/tasting_record_in_feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasting_record_feed_page.freezed.dart';

part 'tasting_record_feed_page.g.dart';

@freezed
class TastingRecordFeedPage with _$TastingRecordFeedPage {
  const factory TastingRecordFeedPage({
    @JsonKey(name: 'results') required List<TastingRecordInFeed> feeds,
    @JsonKey(name: 'has_next') required bool hasNext,
    @JsonKey(name: 'current_page') required int currentPage,
  }) = _TastingRecordFeedPage;

  factory TastingRecordFeedPage.fromJson(Map<String, Object?> json) => _$TastingRecordFeedPageFromJson(json);
}