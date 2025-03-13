import 'package:brew_buds/data/dto/tasted_record/tasted_record_dto.dart';
import 'package:brew_buds/data/mapper/coffee_bean/coffee_bean_mapper.dart';
import 'package:brew_buds/data/mapper/tasted_record/taste_review_mapper.dart';
import 'package:brew_buds/data/mapper/user/user_mapper.dart';
import 'package:brew_buds/model/tasted_record/tasted_record.dart';

extension TastedRecordMapper on TastedRecordDTO {
  TastedRecord toDomain() {
    return TastedRecord(
      id: id,
      author: author.toDomain(),
      bean: bean.toDomain(),
      tastingReview: tastedReview.toDomain(),
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      contents: contents,
      tag: tag,
      imagesUrl: imagesUrl,
      isAuthorFollowing: interaction.isFollowing,
      isLiked: interaction.isLiked,
      isSaved: interaction.isSaved,
    );
  }
}
