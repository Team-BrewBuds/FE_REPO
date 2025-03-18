import 'package:brew_buds/data/dto/common/local_dto.dart';
import 'package:brew_buds/model/common/local.dart';

extension LocalMapper on LocalDTO {
  Local toDomain() => Local(name: name, distance: distance, address: address);
}