import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasting_record_feed_page.freezed.dart';

part 'tasting_record_feed_page.g.dart';

@Freezed(toJson: false)
class TastingRecordFeedPage with _$TastingRecordFeedPage {
  const factory TastingRecordFeedPage({
    @JsonKey(name: 'results') required List<TastingRecordInFeed> feeds,
    @JsonKey(name: 'next', fromJson: _hasNextFromJson) required bool hasNext,
  }) = _TastingRecordFeedPage;

  const TastingRecordFeedPage._();

  factory TastingRecordFeedPage.initial() => const TastingRecordFeedPage(feeds: [], hasNext: true);

  factory TastingRecordFeedPage.fromJson(Map<String, Object?> json) => _$TastingRecordFeedPageFromJson(json);
}

bool _hasNextFromJson(dynamic json) => json != null;