import 'dart:convert';

import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/model/feeds/post_in_feed.dart';

class PopularPostsRepository {
  final PostApi _api = PostApi();

  PopularPostsRepository._();

  static final PopularPostsRepository _instance = PopularPostsRepository._();

  static PopularPostsRepository get instance => _instance;

  factory PopularPostsRepository() => instance;

  Future<DefaultPage<PostInFeed>> fetchPopularPostsPage({
    required String subject,
    required int pageNo,
  }) {
    return _api
        .fetchPopularPostsPage(
          subject: subject,
          pageNo: pageNo,
        )
        .then(
          (jsonString) {
            final json = jsonDecode(jsonString);
            return DefaultPage.fromJson(json, (jsonT) {
              return PostInFeed.fromJson(jsonT as Map<String, dynamic>);
            });
          },
        );
  }
}
