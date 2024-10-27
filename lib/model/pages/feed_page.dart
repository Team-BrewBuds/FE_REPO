import 'package:brew_buds/model/feeds/feed.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:brew_buds/model/feeds/tasting_record_in_feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'feed_page.freezed.dart';

part 'feed_page.g.dart';

@Freezed(toJson: false)
class FeedPage with _$FeedPage {
  const factory FeedPage({
    @JsonKey(name: 'results', fromJson: _feedFromJson) required List<Feed> feeds,
    @JsonKey(name: 'has_next') required bool hasNext,
    @JsonKey(name: 'current_page') required int currentPage,
  }) = _FeedPage;

  const FeedPage._();

  factory FeedPage.initial() => const FeedPage(feeds: [], hasNext: true, currentPage: 0);

  factory FeedPage.fromJson(Map<String, Object?> json) => _$FeedPageFromJson(json);
}

List<Feed> _feedFromJson(dynamic result) {
  return (result as List<dynamic>).map((feedJson) {
    if (feedJson.containsKey('tasted_records')) {
      return PostInFeed.fromJson(feedJson);
    } else {
      return TastingRecordInFeed.fromJson(feedJson);
    }
  }).toList();
}
