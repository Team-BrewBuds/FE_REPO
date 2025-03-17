import 'package:json_annotation/json_annotation.dart';

part 'interaction_dto.g.dart';

@JsonSerializable(createToJson: false)
class InteractionDTO {
  @JsonKey(name: 'is_user_noted', defaultValue: false)
  final bool isSaved;
  @JsonKey(name: 'is_user_liked', defaultValue: false)
  final bool isLiked;
  @JsonKey(name: 'is_user_following', defaultValue: false)
  final bool isFollowing;

  factory InteractionDTO.fromJson(Map<String, dynamic> json) => _$InteractionDTOFromJson(json);

  static InteractionDTO defaultInteraction() =>
      const InteractionDTO(isSaved: false, isLiked: false, isFollowing: false);

  const InteractionDTO({
    required this.isSaved,
    required this.isLiked,
    required this.isFollowing,
  });
}
