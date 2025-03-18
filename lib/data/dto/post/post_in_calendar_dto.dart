import 'package:brew_buds/data/dto/post/post_subject_en_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_in_calendar_dto.g.dart';

@JsonSerializable(createToJson: false)
class PostInCalendarDTO {
  final int id;
  final String title;
  final String author;
  final PostSubjectEnDTO subject;
  @JsonKey(name: 'first_photo', defaultValue: '')
  final String thumbnail;
  @JsonKey(name: 'created_at')
  final String createdAt;

  factory PostInCalendarDTO.fromJson(Map<String, dynamic> json) => _$PostInCalendarDTOFromJson(json);

  const PostInCalendarDTO({
    required this.id,
    required this.title,
    required this.author,
    required this.subject,
    required this.thumbnail,
    required this.createdAt,
  });
}