import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_profile_dto.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';

extension TastedRecordInProfileMapper on TastedRecordInProfileDTO {
  TastedRecordInProfile toDomain() => TastedRecordInProfile(
        id: id,
        beanName: beanName,
        rating: rating,
        imageUrl: imageUrl,
        likeCount: likeCount,
      );
}
