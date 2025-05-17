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
  ActivityItem toDomain() {
    final String imagePath;

    if (type == 'single') {
      if (roastingPoint > 0 && roastingPoint <= 5) {
        imagePath = 'assets/images/coffee_bean/single_$roastingPoint.png';
      } else {
        imagePath = 'assets/images/coffee_bean/single_3.png';
      }
    } else if (type == 'blend') {
      imagePath = 'assets/images/coffee_bean/blend.png';
    } else {
      imagePath = '';
    }

    return ActivityItem.coffeeBean(id: id, name: name, rating: rating, imagePath: imagePath);
  }
}
