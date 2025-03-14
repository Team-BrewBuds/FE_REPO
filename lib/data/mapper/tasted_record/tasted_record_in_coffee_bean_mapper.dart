import 'package:brew_buds/data/dto/tasted_record/tasted_record_for_coffee_bean_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_coffee_bean.dart';

extension TastedRecordInCoffeeBeanMapper on TastedRecordInCoffeeBeanDTO {
  TastedRecordInCoffeeBean toDomain() {
    return TastedRecordInCoffeeBean(
      id: id,
      nickname: nickname,
      contents: contents,
      beanName: beanName,
      rating: rating,
      beanType: beanType.toDomain(),
      flavors: flavors,
      photoUrl: photoUrl,
    );
  }
}
