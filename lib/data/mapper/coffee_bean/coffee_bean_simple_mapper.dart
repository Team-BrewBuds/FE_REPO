import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_simple_dto.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_simple.dart';

extension CoffeeBeanSimpleMapper on CoffeeBeanSimpleDTO {
  CoffeeBeanSimple toDomain() => CoffeeBeanSimple(id: id, name: name);
}