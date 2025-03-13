import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_feed_dto.dart';
import 'package:brew_buds/data/mapper/user/user_mapper.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_feed.dart';

extension TastedRecordInFeedMapper on TastedRecordInFeedDTO {
  TastedRecordInFeed toDomain() {
    return TastedRecordInFeed(
      id: id,
      author: author.toDomain(),
      isAuthorFollowing: interaction.isFollowing,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      commentsCount: commentsCount,
      beanName: beanName,
      beanType: beanType,
      contents: contents,
      rating: rating,
      flavors: flavors,
      tag: tag,
      imagesUrl: imagesUrl,
      isSaved: interaction.isSaved,
      isLiked: interaction.isLiked,
    );
  }
}
