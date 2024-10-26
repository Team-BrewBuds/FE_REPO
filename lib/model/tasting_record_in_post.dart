import 'package:flutter/foundation.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'tasting_record_in_post.freezed.dart';

part 'tasting_record_in_post.g.dart';

@freezed
class TastingRecordInPost with _$TastingRecordInPost {
  const factory TastingRecordInPost({
    required int id,
    @JsonKey(name: 'bean_name')
    required String beanName,
    @JsonKey(name: 'bean_type')
    required String beanType,
    @JsonKey(name: 'content')
    required String contents,
    @JsonKey(name: 'star_rating')
    required double rating,
    @JsonKey(name: 'flavor')
    required List<String> flavors,
    @JsonKey(name: 'photos')
    required List<String> imagesUri,
  }) = _TastingRecordInPost;

  const TastingRecordInPost._();

  String get thumbnailUri => imagesUri.firstOrNull ?? '';

  factory TastingRecordInPost.fromJson(Map<String, Object?> json) => _$TastingRecordInPostFromJson(json);
}