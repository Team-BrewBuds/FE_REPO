import 'dart:convert';

import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/dto/post/post_dto.dart';
import 'package:brew_buds/data/mapper/post/post_mapper.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/post/post.dart';

class PopularPostsRepository {
  final PostApi _api = PostApi();

  PopularPostsRepository._();

  static final PopularPostsRepository _instance = PopularPostsRepository._();

  static PopularPostsRepository get instance => _instance;

  factory PopularPostsRepository() => instance;

  Future<DefaultPage<Post>> fetchPopularPostsPage({
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
              return PostDTO.fromJson(jsonT as Map<String, dynamic>).toDomain();
            });
          },
        );
  }
}
