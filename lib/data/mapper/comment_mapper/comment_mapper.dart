import 'package:brew_buds/data/dto/comment/comment_dto.dart';
import 'package:brew_buds/data/mapper/user/user_mapper.dart';
import 'package:brew_buds/model/comments.dart';

extension CommentMapper on CommentDTO {
  Comment toDomain() => Comment(
      id: id,
      author: author.toDomain(),
      content: content,
      likeCount: likeCount,
      createdAt: createdAt,
      reComments: reComments.map((e) => e.toDomain()).toList(),
      isLiked: isLiked,
    );
}
