import 'package:brew_buds/data/dto/recommended/recommended_category_dto.dart';
import 'package:brew_buds/model/recommended/recommended_category.dart';

extension RecommendedCategoryMapper on RecommendedCategoryDTO {
  RecommendedCategory toDomain() {
    switch (this) {
      case RecommendedCategoryDTO.cafeTour:
        return RecommendedCategory.cafeTour;
      case RecommendedCategoryDTO.coffeeExtraction:
        return RecommendedCategory.coffeeExtraction;
      case RecommendedCategoryDTO.coffeeExtraction:
        return RecommendedCategory.coffeeExtraction;
      case RecommendedCategoryDTO.coffeeStudy:
        return RecommendedCategory.coffeeStudy;
      case RecommendedCategoryDTO.cafeAlba:
        return RecommendedCategory.cafeAlba;
      case RecommendedCategoryDTO.cafeWork:
        return RecommendedCategory.cafeWork;
      case RecommendedCategoryDTO.cafeOperation:
        return RecommendedCategory.cafeOperation;
    }
  }
}