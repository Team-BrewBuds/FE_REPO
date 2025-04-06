import 'package:brew_buds/data/dto/post/post_subject_en_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'noted_post_dto.g.dart';

@JsonSerializable(createToJson: false)
class NotedPostDTO {
  @JsonKey(name: 'post_id', defaultValue: 0)
  final int id;
  @JsonKey(name: 'nickname', defaultValue: '')
  final String author;
  @JsonKey(defaultValue: PostSubjectEnDTO.normal)
  final PostSubjectEnDTO subject;
  @JsonKey(defaultValue: '')
  final String title;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'photo_url', defaultValue: null)
  final String? imageUrl;

  factory NotedPostDTO.fromJson(Map<String, dynamic> json) => _$NotedPostDTOFromJson(json);

  const NotedPostDTO({
    required this.id,
    required this.author,
    required this.subject,
    required this.title,
    required this.createdAt,
    this.imageUrl,
  });
}
