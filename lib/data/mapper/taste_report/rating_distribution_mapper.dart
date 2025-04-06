import 'package:brew_buds/data/dto/taste_report/rating_distribution_dto.dart';
import 'package:brew_buds/model/taste_report/rating_distribution.dart';

extension RatingDistributionMapper on RatingDistributionDTO {
  RatingDistribution toDomain() => RatingDistribution(
        ratingDistribution: ratingDistribution,
        mostRating: mostRating,
        avgRating: avgRating,
        ratingCount: ratingCount,
      );
}
