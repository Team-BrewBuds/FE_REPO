import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_in_calendar_dto.dart';
import 'package:brew_buds/data/dto/post/post_in_calendar_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_calendar_dto.dart';
import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/model/taste_report/activity_item.dart';

extension PostActivityMapper on PostInCalendarDTO {
  ActivityItem toDomain() => ActivityItem.post(
        id: id,
        title: title,
        author: author,
        subject: subject.toDomain(),
        thumbnail: thumbnail,
        createdAt: createdAt,
      );
}

extension TastedRecordActivityMapper on TastedRecordInCalendarDTO {
  ActivityItem toDomain() => ActivityItem.tastedRecord(
        id: id,
        beanName: beanName,
        rating: rating,
        flavors: flavors,
        thumbnail: thumbnail,
      );
}

extension CoffeeBeanActivityMapper on CoffeeBeanInCalendarDTO {
  ActivityItem toDomain() => ActivityItem.coffeeBean(id: id, name: name, rating: rating, thumbnail: thumbnail);
}
