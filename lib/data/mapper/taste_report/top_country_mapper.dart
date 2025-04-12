import 'package:brew_buds/data/dto/taste_report/top_origin_dto.dart';
import 'package:brew_buds/model/taste_report/top_country.dart';

extension TopCountryMapper on TopOriginDTO {
  TopCountry toDomain() => TopCountry(country: origin, percent: double.tryParse(percent) ?? 0.0);
}
