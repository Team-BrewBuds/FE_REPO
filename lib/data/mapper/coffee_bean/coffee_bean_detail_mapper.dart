import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_detail_dto.dart';
import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_type_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/data/mapper/common/top_flavor_mapper.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean_detail.dart';

extension CoffeeBeanDetailMapper on CoffeeBeanDetailDTO {
  CoffeeBeanDetail toDomain() {
    final String imagePath;

    switch (type) {
      case CoffeeBeanTypeDTO.singleOrigin:
        final roastPoint = this.roastPoint;
        if (roastPoint != null && roastPoint > 0 && roastPoint <= 5) {
          imagePath = 'assets/images/coffee_bean/single_$roastPoint.png';
        } else {
          imagePath = 'assets/images/coffee_bean/single_3.png';
        }
      case CoffeeBeanTypeDTO.blend:
        imagePath = 'assets/images/coffee_bean/blend.png';
    }

    return CoffeeBeanDetail(
      id: id,
      type: type.toDomain(),
      name: name,
      country: country,
      imagePath: imagePath,
      isDecaf: isDecaf,
      rating: double.tryParse(rating) ?? 0.0,
      recordCount: recordCount,
      topFlavors: topFlavors.map((e) => e.toDomain()).toList()..sort((a, b) => b.percent.compareTo(a.percent)),
      flavors: beanTaste.flavors,
      body: beanTaste.body,
      acidity: beanTaste.acidity,
      bitterness: beanTaste.bitterness,
      sweetness: beanTaste.sweetness,
      region: region,
      extraction: extraction,
      roastPoint: roastPoint,
      process: process,
      beverageType: beverageType,
      roastery: roastery,
      variety: variety,
      isUserNoted: isUserNoted,
      isUserCreated: isUserCreated,
      isOfficial: isOfficial,
    );
  }
}
