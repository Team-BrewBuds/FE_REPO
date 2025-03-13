import 'package:brew_buds/data/dto/common/interaction_dto.dart';
import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tasted_record_in_feed_dto.g.dart';

@JsonSerializable(createToJson: false)
class TastedRecordInFeedDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: UserDTO.defaultUser)
  final UserDTO author;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'view_cnt', defaultValue: 0)
  final int viewCount;
  @JsonKey(name: 'likes', defaultValue: 0)
  final int likeCount;
  @JsonKey(name: 'comments', defaultValue: 0)
  final int commentsCount;
  @JsonKey(name: 'bean_name', defaultValue: '')
  final String beanName;
  @JsonKey(name: 'bean_type', defaultValue: '')
  final String beanType;
  @JsonKey(name: 'content', defaultValue: '')
  final String contents;
  @JsonKey(name: 'star_rating', defaultValue: 0)
  final double rating;
  @JsonKey(name: 'flavor', fromJson: _flavorFromJson)
  final List<String> flavors;
  @JsonKey(defaultValue: '')
  final String tag;
  @JsonKey(name: 'photos', fromJson: _photosFromJson, defaultValue: [])
  final List<String> imagesUrl;
  @JsonKey(defaultValue: InteractionDTO.defaultInteraction)
  final InteractionDTO interaction;

  factory TastedRecordInFeedDTO.fromJson(Map<String, dynamic> json) => _$TastedRecordInFeedDTOFromJson(json);

  const TastedRecordInFeedDTO({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.viewCount,
    required this.likeCount,
    required this.commentsCount,
    required this.beanName,
    required this.beanType,
    required this.contents,
    required this.rating,
    required this.flavors,
    required this.tag,
    required this.imagesUrl,
    required this.interaction,
  });
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
