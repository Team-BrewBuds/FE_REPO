import 'package:brew_buds/model/feeds/post_in_feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'popular_post_page.freezed.dart';

part 'popular_post_page.g.dart';

@Freezed(toJson: false)
class PopularPostsPage with _$PopularPostsPage {
  const factory PopularPostsPage({
    @JsonKey(name: 'results') required List<PostInFeed> popularPosts,
    @JsonKey(name: 'next', fromJson: _hasNextFromJson) required bool hasNext,
  }) = _PopularPostPage;

  const PopularPostsPage._();

  factory PopularPostsPage.initial() => const PopularPostsPage(popularPosts: [], hasNext: true);

  factory PopularPostsPage.fromJson(Map<String, Object?> json) => _$PopularPostsPageFromJson(json);
}

bool _hasNextFromJson(dynamic json) => json != null;