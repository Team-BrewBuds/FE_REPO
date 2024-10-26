import 'package:brew_buds/model/feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'feed_page.freezed.dart';

part 'feed_page.g.dart';

@Freezed(genericArgumentFactories: true, toJson: false)
class FeedPage<T extends Feed> with _$FeedPage {
  const factory FeedPage({
    @JsonKey(name: 'result') required List<T> feeds,
    required bool hasNext,
    @JsonKey(name: 'current_page') required int currentPage,
  }) = _FeedPage;

  const FeedPage._();

  factory FeedPage.initial() => const FeedPage(feeds: [], hasNext: true, currentPage: 1);

  factory FeedPage.fromJson(
    Map<String, Object?> json,
    T Function(dynamic json) fromJsonT,
  ) =>
      _$FeedPageFromJson(json, fromJsonT);
}
