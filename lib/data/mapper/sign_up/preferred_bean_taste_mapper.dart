import 'package:brew_buds/model/common/preferred_bean_taste.dart';

extension PreferredBeanTasteToJson on PreferredBeanTaste {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (body != 0) {
      json['body'] = body;
    }
    if (acidity != 0) {
      json['acidity'] = acidity;
    }
    if (bitterness != 0) {
      json['bitterness'] = bitterness;
    }
    if (sweetness != 0) {
      json['sweetness'] = sweetness;
    }
    return json;
  }
}
