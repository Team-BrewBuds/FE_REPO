import 'package:brew_buds/model/coffee_bean_type.dart';
import 'package:brew_buds/model/feed.dart';
import 'package:brew_buds/model/tasting_record_share_mixin.dart';

final class TastingRecord extends Feed with TastingRecordShareMixin {
  final List<String> imageUriList;
  @override
  final List<String> tags;
  @override
  final String name;
  @override
  final String body;
  @override
  final double rating;
  @override
  final CoffeeBeanType coffeeBeanType;

  TastingRecord({
    required super.writer,
    required super.writingTime,
    required super.hits,
    required super.likeCount,
    required super.commentsCount,
    required super.isLike,
    required super.isLeaveComment,
    required super.isSaved,
    required this.imageUriList,
    required this.tags,
    required this.name,
    required this.body,
    required this.rating,
    required this.coffeeBeanType,
  });

  @override
  String get thumbnailUri => imageUriList.first;
}