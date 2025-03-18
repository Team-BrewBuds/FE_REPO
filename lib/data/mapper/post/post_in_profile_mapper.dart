import 'package:brew_buds/data/dto/post/post_in_profile_dto.dart';
import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/model/post/post_in_profile.dart';

extension PostInProfileMapper on PostInProfileDTO {
  PostInProfile toDomain() => PostInProfile(
        id: id,
        author: author,
        subject: subject.toDomain(),
        title: title,
        createdAt: createdAt,
    imageUrl: imageUrl,
    tastedRecordImageUrl: tastedRecordImageUrl,
      );
}
