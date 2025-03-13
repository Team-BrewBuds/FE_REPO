import 'package:brew_buds/data/dto/coffee_bean/recommended_coffee_bean_dto.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';

extension RecommendedCoffeeBeanMapper on RecommendedCoffeeBeanDTO {
  RecommendedCoffeeBean toDomain() {
    return RecommendedCoffeeBean(
      id: id,
      name: name,
      imageUrl: imageUrl,
      rating: rating,
      recordCount: recordCount,
    );
  }
}
