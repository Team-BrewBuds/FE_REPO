import 'package:brew_buds/model/post/post_subject.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post_in_profile.freezed.dart';

@freezed
class PostInProfile with _$PostInProfile {
  const factory PostInProfile({
    required int id,
    required String author,
    required PostSubject subject,
    required String title,
    required String createdAt,
    required String? imageUrl,
    required String? tastedRecordImageUrl,
  }) = _PostInProfile;
}
