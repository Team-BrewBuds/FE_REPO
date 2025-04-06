import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_post_dto.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_post.dart';

extension TastedRecordInPostMapper on TastedRecordInPostDTO {
  TastedRecordInPost toDomain() {
    return TastedRecordInPost(
      id: id,
      beanName: beanName,
      beanType: beanType,
      contents: contents,
      rating: rating,
      flavors: flavors,
      imagesUrl: imagesUrl,
    );
  }
}
