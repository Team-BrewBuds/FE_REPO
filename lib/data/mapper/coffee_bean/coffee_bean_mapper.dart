import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_type_mapper.dart';
import 'package:brew_buds/model/coffee_bean/coffee_bean.dart';

extension CoffeeBeanMapper on CoffeeBeanDTO {
  CoffeeBean toDomain() {
    return CoffeeBean(
      id: id,
      name: name,
      type: type.toDomain(),
      isDecaf: isDecaf,
      country: country,
      region: region,
      variety: variety,
      extraction: extraction,
      process: process,
      roastery: roastery,
      beverageType: beverageType,
      isUserCreated: isUserCreated,
      isOfficial: isOfficial,
      imageUri: imageUri,
    );
  }
}

extension CoffeeBeanToJson on CoffeeBean {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};

    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }

    String? nullableString(String? string) {
      if (string != null && string.isEmpty) {
        return null;
      } else {
        return string;
      }
    }

    writeNotNull('name', nullableString(name));
    writeNotNull('bean_type', type?.toJson());
    writeNotNull('region', nullableString(region));
    writeNotNull('origin_country', _countryToJson());
    writeNotNull('image_url', nullableString(imageUri));
    writeNotNull('is_decaf', isDecaf);
    writeNotNull('extraction', nullableString(extraction));
    writeNotNull('roast_point', roastPoint);
    writeNotNull('process', nullableString(process?.join(',')));
    writeNotNull('bev_type', beverageType);
    writeNotNull('roastery', nullableString(roastery));
    writeNotNull('variety', nullableString(variety));
    writeNotNull('is_user_created', isUserCreated);
    writeNotNull('is_official', isOfficial);

    return json;
  }

  String? _countryToJson() {
    return country?.where((element) => element.isNotEmpty).join(',');
  }
}
