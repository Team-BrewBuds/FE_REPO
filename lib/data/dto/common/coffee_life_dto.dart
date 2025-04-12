import 'package:json_annotation/json_annotation.dart';

enum CoffeeLifeDTO {
  @JsonValue('cafe_tour')
  cafeTour,
  @JsonValue('coffee_extraction')
  coffeeExtraction,
  @JsonValue('coffee_study')
  coffeeStudy,
  @JsonValue('cafe_alba')
  cafeAlba,
  @JsonValue('cafe_work')
  cafeWork,
  @JsonValue('cafe_operation')
  cafeOperation;
}
