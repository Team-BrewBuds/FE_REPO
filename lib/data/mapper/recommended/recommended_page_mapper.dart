import 'package:brew_buds/data/dto/recommended/recommended_page_dto.dart';
import 'package:brew_buds/data/mapper/recommended/recommended_category_mapper.dart';
import 'package:brew_buds/data/mapper/recommended/recommended_user_mapper.dart';
import 'package:brew_buds/model/recommended/recommended_page.dart';

extension RecommendedPageMapper on RecommendedPageDTO {
  RecommendedPage toDomain() {
    return RecommendedPage(
      users: users.map((e) => e.toDomain()).toList(),
      category: category.toDomain(),
    );
  }
}
