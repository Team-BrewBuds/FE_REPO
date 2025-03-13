import 'package:brew_buds/data/dto/coffee_bean/coffee_bean_dto.dart';
import 'package:brew_buds/data/dto/common/interaction_dto.dart';
import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/taste_review_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordDTO {
  final int id;
  @JsonKey(defaultValue: UserDTO.defaultUser)
  final UserDTO author;
  @JsonKey(name: 'photos', fromJson: _photosFromJson, defaultValue: [])
  final List<String> imagesUrl;
  @JsonKey(defaultValue: CoffeeBeanDTO.defaultCoffeeBean)
  final CoffeeBeanDTO bean;
  @JsonKey(name: 'taste_review', defaultValue: TasteReviewDTO.defaultTasteReview)
  final TasteReviewDTO tastedReview;
  @JsonKey(name: 'likes', defaultValue: 0)
  final int likeCount;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(defaultValue: InteractionDTO.defaultInteraction)
  final InteractionDTO interaction;
  @JsonKey(name: 'content', defaultValue: '')
  final String contents;
  @JsonKey(name: 'view_cnt', defaultValue: 0)
  final int viewCount;
  @JsonKey(name: 'is_private', defaultValue: false)
  final bool isPrivate;
  @JsonKey(defaultValue: '')
  final String tag;

  factory TastedRecordDTO.fromJson(Map<String, dynamic> json) => _$TastedRecordDTOFromJson(json);

  const TastedRecordDTO({
    required this.id,
    required this.author,
    required this.imagesUrl,
    required this.bean,
    required this.tastedReview,
    required this.likeCount,
    required this.createdAt,
    required this.interaction,
    required this.contents,
    required this.viewCount,
    required this.isPrivate,
    required this.tag,
  });
}

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
