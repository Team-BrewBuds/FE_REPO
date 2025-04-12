import 'package:brew_buds/data/dto/common/interaction_dto.dart';
import 'package:brew_buds/data/dto/post/post_subject_dto.dart';
import 'package:brew_buds/data/dto/tasted_record/tasted_record_in_post_dto.dart';
import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostDTO {
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
  @JsonKey(unknownEnumValue: PostSubjectDTO.normal, defaultValue: PostSubjectDTO.normal)
  final PostSubjectDTO subject;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(name: 'content', defaultValue: '')
  final String contents;
  @JsonKey(defaultValue: '')
  final String tag;
  @JsonKey(name: 'photos', fromJson: _photosFromJson, defaultValue: [])
  final List<String> imagesUrl;
  @JsonKey(name: 'tasted_records', defaultValue: [])
  List<TastedRecordInPostDTO> tastingRecords;
  @JsonKey(defaultValue: InteractionDTO.defaultInteraction)
  final InteractionDTO interaction;

  factory PostDTO.fromJson(Map<String, dynamic> json) => _$PostDTOFromJson(json);

  PostDTO({
    required this.id,
    required this.author,
    required this.createdAt,
    required this.viewCount,
    required this.likeCount,
    required this.commentsCount,
    required this.subject,
    required this.title,
    required this.contents,
    required this.tag,
    required this.imagesUrl,
    required this.tastingRecords,
    required this.interaction,
  });
}

List<String> _photosFromJson(dynamic photosJson) {
  return (photosJson as List<dynamic>).map((photosJson) => photosJson['photo_url'] as String).toList();
}
