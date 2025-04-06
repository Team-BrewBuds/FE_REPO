import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_type_dto.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_type.dart';

extension CoffeeBeanTypeMapper on CoffeeBeanTypeDTO {
  CoffeeBeanType toDomain() {
    switch (this) {
      case CoffeeBeanTypeDTO.singleOrigin:
        return CoffeeBeanType.singleOrigin;
      case CoffeeBeanTypeDTO.blend:
        return CoffeeBeanType.blend;
    }
  }
}

extension CoffeeBeanTypeToJson on CoffeeBeanType {
  String toJson() {
    switch (this) {
      case CoffeeBeanType.singleOrigin:
        return 'single';
      case CoffeeBeanType.blend:
        return 'blend';
    }
  }
}