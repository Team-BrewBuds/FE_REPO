import 'package:brew_buds/data/dto/common/preferred_bean_taste_dto.dart';
import 'package:brew_buds/model/common/preferred_bean_taste.dart';

extension PreferredBeanTasteMapper on PreferredBeanTasteDTO {
  PreferredBeanTaste toDomain() => PreferredBeanTaste(
        body: body,
        bitterness: bitterness,
        acidity: acidity,
        sweetness: sweetness,
      );
}

extension PreferredBeanTastedToJson on PreferredBeanTaste {
  Map<String, dynamic> toJson() {
    if (body != 0 && bitterness != 0 && acidity != 0 && sweetness != 0) {
      return {'body': body, 'bitterness': bitterness, 'acidity': acidity, 'sweetness': sweetness};
    } else {
      return {};
    }
  }
}
