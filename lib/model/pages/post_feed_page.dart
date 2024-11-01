import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post_feed_page.freezed.dart';

part 'post_feed_page.g.dart';

@Freezed(toJson: false)
class PostFeedPage with _$PostFeedPage {
  const factory PostFeedPage({
    @JsonKey(name: 'results') required List<PostInFeed> feeds,
    @JsonKey(name: 'next', fromJson: _hasNextFromJson) required bool hasNext,
  }) = _PostFeedPage;

  const PostFeedPage._();

  factory PostFeedPage.initial() => const PostFeedPage(feeds: [], hasNext: true);

  factory PostFeedPage.fromJson(Map<String, Object?> json) => _$PostFeedPageFromJson(json);
}

bool _hasNextFromJson(dynamic json) => json != null;