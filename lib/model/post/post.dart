import 'package:brew_buds/model/common/user.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'post.freezed.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required int id,
    required User author,
    required bool isAuthorFollowing,
    required String createdAt,
    required int viewCount,
    required int likeCount,
    required int commentsCount,
    required PostSubject subject,
    required String title,
    required String contents,
    required String tag,
    @Default([]) List<String> imagesUrl,
    @Default([]) List<TastedRecordInPost> tastingRecords,
    required bool isSaved,
    required bool isLiked,
  }) = _Post;
}