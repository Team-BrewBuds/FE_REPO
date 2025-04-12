import 'package:brew_buds/data/dto/post/post_subject_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_in_profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostInProfileDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String author;
  @JsonKey(defaultValue: PostSubjectDTO.normal)
  final PostSubjectDTO subject;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'represent_post_photo')
  final String? imageUrl;
  @JsonKey(name: 'tasted_records_photo')
  final String? tastedRecordImageUrl;

  factory PostInProfileDTO.fromJson(Map<String, dynamic> json) => _$PostInProfileDTOFromJson(json);

  const PostInProfileDTO({
    required this.id,
    required this.author,
    required this.subject,
    required this.title,
    required this.createdAt,
    this.imageUrl,
    this.tastedRecordImageUrl,
  });
}
