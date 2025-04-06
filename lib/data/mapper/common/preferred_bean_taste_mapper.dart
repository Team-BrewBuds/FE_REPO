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
  Map<String, dynamic> toJson() => {'body': body, 'bitterness': bitterness, 'acidity': acidity, 'sweetness': sweetness};
}
