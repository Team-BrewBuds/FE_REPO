import 'package:brew_buds/model/recommended/recommended_category.dart';
import 'package:brew_buds/model/recommended/recommended_user.dart';
import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recommended_page.freezed.dart';

@freezed
class RecommendedPage with _$RecommendedPage {
  const factory RecommendedPage({
    required List<RecommendedUser> users,
    required RecommendedCategory category,
  }) = _RecommendedPage;
}
