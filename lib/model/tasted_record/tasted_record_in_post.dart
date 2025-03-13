import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasted_record_in_post.freezed.dart';

@freezed
class TastedRecordInPost with _$TastedRecordInPost {
  const factory TastedRecordInPost({
    required int id,
    required String beanName,
    required String beanType,
    required String contents,
    required double rating,
    required List<String> flavors,
    required List<String> imagesUrl,
  }) = _TastedRecordInPost;

  const TastedRecordInPost._();

  String get thumbnailUrl => imagesUrl.firstOrNull ?? '';
}