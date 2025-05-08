import 'package:brew_buds/data/dto/coffee_bean/recommended_coffee_bean_dto.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';

extension RecommendedCoffeeBeanMapper on RecommendedCoffeeBeanDTO {
  RecommendedCoffeeBean toDomain() {
    final String imagePath;

    if (type == 'single') {
      if (roastPoint > 0 && roastPoint <= 5) {
        imagePath = 'assets/images/coffee_bean/single_$roastPoint.png';
      } else {
        imagePath = 'assets/images/coffee_bean/single_3.png';
      }
    } else if (type == 'blend') {
      imagePath = 'assets/images/coffee_bean/blend.png';
    } else {
      imagePath = '';
    }

    return RecommendedCoffeeBean(
      id: id,
      name: name,
      imagePath: imagePath,
      rating: rating,
      recordCount: recordCount,
    );
  }
}
