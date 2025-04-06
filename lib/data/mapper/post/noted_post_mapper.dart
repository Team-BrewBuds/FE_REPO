import 'package:brew_buds/data/dto/post/noted_post_dto.dart';
import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/model/noted/noted_object.dart';

extension NotedPostMapper on NotedPostDTO {
  NotedObject toDomain() => NotedObject.post(
        id: id,
        author: author,
        subject: subject.toDomain(),
        title: title,
        createdAt: createdAt,
      );
}
