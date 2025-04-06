import 'package:brew_buds/model/common/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';


part 'tasted_record_in_feed.freezed.dart';

@freezed
class TastedRecordInFeed with _$TastedRecordInFeed {
  const factory TastedRecordInFeed({
    required int id,
    required User author,
    required bool isAuthorFollowing,
    required String createdAt,
    required int viewCount,
    required int likeCount,
    required int commentsCount,
    required String beanName,
    required String beanType,
    required String contents,
    required double rating,
    required List<String> flavors,
    required String tag,
    required List<String> imagesUrl,
    required bool isSaved,
    required bool isLiked,
  }) = _TastedRecordInFeed;

  const TastedRecordInFeed._();

  String get thumbnailUri => imagesUrl.firstOrNull ?? '';
}