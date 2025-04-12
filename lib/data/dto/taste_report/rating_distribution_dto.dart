import 'package:json_annotation/json_annotation.dart';

part 'rating_distribution_dto.g.dart';

@JsonSerializable(createToJson: false)
class RatingDistributionDTO {
  @JsonKey(name: 'star_distribution', defaultValue: {})
  final Map<String, int> ratingDistribution;
  @JsonKey(name: 'most_common_star', defaultValue: 0.0)
  final double mostRating;
  @JsonKey(name: 'avg_star', defaultValue: 0.0)
  final double avgRating;
  @JsonKey(name: 'total_ratings', defaultValue: 0)
  final int ratingCount;

  factory RatingDistributionDTO.fromJson(Map<String, dynamic> json) => _$RatingDistributionDTOFromJson(json);

  const RatingDistributionDTO({
    required this.ratingDistribution,
    required this.mostRating,
    required this.avgRating,
    required this.ratingCount,
  });
}
