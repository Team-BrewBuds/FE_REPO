import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_in_profile_dto.dart';
import 'package:brew_buds/model/coffee_bean/bean_in_profile.dart';

extension CoffeeBeanInProfileMapper on CoffeeBeanInProfileDTO {
  BeanInProfile toDomain() {
    final String imagePath;

    if (type == 'single') {
      if (roastingPoint > 0 && roastingPoint <= 5) {
        imagePath = 'assets/images/coffee_bean/single_$roastingPoint.png';
      } else {
        imagePath = 'assets/images/coffee_bean/single_3.png';
      }
    } else if (type == 'blend') {
      imagePath = 'assets/images/coffee_bean/blend.png';
    } else {
      imagePath = '';
    }

    return BeanInProfile(
        id: id,
        name: name,
        imagePath: imagePath,
        country: country,
        roastingPoint: roastingPoint,
        rating: rating,
        tastedRecordsCount: tastedRecordsCount,
      );
  }
}
