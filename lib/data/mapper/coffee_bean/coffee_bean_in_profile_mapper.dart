import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_in_profile_dto.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';

extension CoffeeBeanInProfileMapper on CoffeeBeanInProfileDTO {
  BeanInProfile toDomain() => BeanInProfile(
        id: id,
        name: name,
        country: country,
        roastingPoint: roastingPoint,
        rating: rating,
        tastedRecordsCount: tastedRecordsCount,
      );
}
