import 'package:brew_buds/data/dto/common/top_flavor_dto.dart';
import 'package:brew_buds/model/common/top_flavor.dart';

extension TopFlavorMapper on TopFlavorDTO {
  TopFlavor toDomain() {
    return TopFlavor(flavor: flavor, percent: percent);
  }
}