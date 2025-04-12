import 'package:brew_buds/data/dto/recommended/recommended_category_dto.dart';
import 'package:brew_buds/data/dto/recommended/recommended_user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'recommended_page_dto.g.dart';

@JsonSerializable(createToJson: false)
class RecommendedPageDTO {
  @JsonKey(defaultValue: [])
  final List<RecommendedUserDTO> users;
  @JsonKey(unknownEnumValue: RecommendedCategoryDTO.cafeTour, defaultValue: RecommendedCategoryDTO.cafeTour)
  final RecommendedCategoryDTO category;

  factory RecommendedPageDTO.fromJson(Map<String, dynamic> json) => _$RecommendedPageDTOFromJson(json);

  const RecommendedPageDTO({
    required this.users,
    required this.category,
  });
}
