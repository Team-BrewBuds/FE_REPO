import 'package:brew_buds/model/common/preferred_bean_taste.dart';

extension PreferredBeanTasteToJson on PreferredBeanTaste {
  Map<String, dynamic> toJson() => <String, dynamic>{
        'body': body,
        'acidity': acidity,
        'bitterness': bitterness,
        'sweetness': sweetness,
      };
}
