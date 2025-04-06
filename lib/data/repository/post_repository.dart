import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/api/post_api.dart';
import 'package:brew_buds/data/api/save_api.dart';
import 'package:brew_buds/data/dto/post/post_dto.dart';
import 'package:brew_buds/data/mapper/post/post_mapper.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/feed/feed.dart';
import 'package:brew_buds/model/post/post.dart';
import 'package:flutter/foundation.dart';

class PostRepository {
  final PostApi _postApi = PostApi();
  final LikeApi _likeApi = LikeApi();
  final SaveApi _saveApi = SaveApi();
  final FollowApi _followApi = FollowApi();

  PostRepository._();

  static final PostRepository _instance = PostRepository._();

  static PostRepository get instance => _instance;

  factory PostRepository() => instance;

  Future<DefaultPage<Feed>> fetchPostPage({required String? subjectFilter, required int pageNo}) async {
    final jsonString = await _postApi.fetchPostFeedPage(subject: subjectFilter, pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return DefaultPage.fromJson(
            json,
            (jsonT) => Feed.post(data: PostDTO.fromJson(jsonT as Map<String, dynamic>).toDomain()),
          );
        } catch (e) {
          return DefaultPage.initState();
        }
      },
      jsonString,
    );
  }

  Future<Post> fetchPost({required int id}) async {
    final jsonString = await _postApi.fetchPost(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return PostDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<void> like({required Post post}) {
    if (post.isLiked) {
      return _likeApi.unlike(type: 'post', id: post.id);
    } else {
      return _likeApi.like(type: 'post', id: post.id);
    }
  }

  Future<void> delete({required int id}) {
    return _postApi.deletePost(id: id);
  }

  Future<void> create({required Map<String, dynamic> data}) {
    return _postApi.createPost(data: data);
  }

  Future<void> save({required Post post}) {
    if (post.isSaved) {
      return _saveApi.unSave(type: 'post', id: post.id);
    } else {
      return _saveApi.save(type: 'post', id: post.id);
    }
  }

  Future<void> follow({required Post post}) {
    if (post.isAuthorFollowing) {
      return _followApi.unFollow(id: post.author.id);
    } else {
      return _followApi.follow(id: post.author.id);
    }
  }
}
