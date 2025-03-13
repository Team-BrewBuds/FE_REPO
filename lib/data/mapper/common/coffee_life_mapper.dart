import 'package:brew_buds/data/dto/common/coffee_life_dto.dart';
import 'package:brew_buds/model/common/coffee_life.dart';

extension CoffeeLifeMapper on CoffeeLifeDTO {
  CoffeeLife toDomain() {
    switch (this) {
      case CoffeeLifeDTO.cafeTour:
        return CoffeeLife.cafeTour;
      case CoffeeLifeDTO.coffeeExtraction:
        return CoffeeLife.coffeeExtraction;
      case CoffeeLifeDTO.coffeeStudy:
        return CoffeeLife.coffeeStudy;
      case CoffeeLifeDTO.cafeAlba:
        return CoffeeLife.cafeAlba;
      case CoffeeLifeDTO.cafeWork:
        return CoffeeLife.cafeWork;
      case CoffeeLifeDTO.cafeOperation:
        return CoffeeLife.cafeOperation;
    }
  }
}

extension CoffeeLifeToJson on CoffeeLife {
  String toJson() => switch (this) {
        CoffeeLife.cafeTour => 'cafe_tour',
        CoffeeLife.coffeeExtraction => 'coffee_extraction',
        CoffeeLife.coffeeStudy => 'coffee_study',
        CoffeeLife.cafeAlba => 'cafe_alba',
        CoffeeLife.cafeWork => 'cafe_work',
        CoffeeLife.cafeOperation => 'cafe_operation',
      };
}
