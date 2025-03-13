import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';
import 'package:brew_buds/model/common/user.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'tasted_record.freezed.dart';

@freezed
class TastedRecord with _$TastedRecord {
  const factory TastedRecord({
    required int id,
    required User author,
    required bool isAuthorFollowing,
    required CoffeeBean bean,
    required TasteReview tastingReview,
    required String createdAt,
    required int viewCount,
    required int likeCount,
    required bool isSaved,
    required bool isLiked,
    required String contents,
    required String tag,
    required List<String> imagesUrl,
  }) = _TastedRecord;
}
