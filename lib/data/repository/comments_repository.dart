import 'dart:convert';

import 'package:brew_buds/data/api/comment_api.dart';
import 'package:brew_buds/data/api/like_api.dart';
import 'package:brew_buds/data/dto/comment/comment_dto.dart';
import 'package:brew_buds/data/mapper/comment_mapper/comment_mapper.dart';
import 'package:brew_buds/model/comments.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:flutter/foundation.dart';

class CommentsRepository {
  final LikeApi _likeApi;
  final CommentApi _api;

  CommentsRepository._()
      : _api = CommentApi(),
        _likeApi = LikeApi();

  static final CommentsRepository _instance = CommentsRepository._();

  static CommentsRepository get instance => _instance;

  factory CommentsRepository() => instance;

  Future<DefaultPage<Comment>> fetchCommentsPage({
    required String feedType,
    required int id,
    required int pageNo,
  }) async {
    final jsonString = await _api.fetchCommentsPage(feedType: feedType, id: id, pageNo: pageNo);
    return compute(
      (jsonString) {
        try {
          return DefaultPage.fromJson(
            jsonDecode(jsonString) as Map<String, dynamic>,
            (object) => CommentDTO.fromJson(object as Map<String, dynamic>).toDomain(),
          );
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }

  Future<Comment> createNewComment({
    required String feedType,
    required int id,
    required String content,
    int? parentId,
  }) async {
    final json = jsonDecode(await _api.createComment(
      feedType: feedType,
      id: id,
      data: parentId == null
          ? <String, dynamic>{"content": content}
          : <String, dynamic>{"content": content, "parent": parentId},
    )) as Map<String, dynamic>;

    return CommentDTO.fromJson(json).toDomain();
  }

  Future<void> deleteComment({required int id}) => _api.deleteComment(id: id);

  Future<void> likeComment({required int id}) => _likeApi.like(type: 'comment', id: id);

  Future<void> unLikeComment({required int id}) => _likeApi.unlike(type: 'comment', id: id);

  Future<Comment> fetchComment({required int id}) async {
    final jsonString = await _api.fetchComment(id: id);
    return compute(
      (jsonString) {
        try {
          final json = jsonDecode(jsonString) as Map<String, dynamic>;
          return CommentDTO.fromJson(json).toDomain();
        } catch (e) {
          rethrow;
        }
      },
      jsonString,
    );
  }
}
