import 'package:brew_buds/data/dto/tasted_record/noted_tasted_record_dto.dart';
import 'package:brew_buds/model/noted/noted_object.dart';

extension NotedTastedRecordMapper on NotedTastedRecordDTO {
  NotedObject toDomain() => NotedObject.tastedRecord(id: id, beanName: beanName, flavor: flavor, imageUrl: imageUrl);
}