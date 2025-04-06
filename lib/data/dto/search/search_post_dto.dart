import 'package:brew_buds/data/dto/post/post_subject_en_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'search_post_dto.g.dart';

@JsonSerializable(createToJson: false)
class SearchPostDTO {
  @JsonKey(name: 'id')
  final int id;
  @JsonKey(name: 'author', defaultValue: '')
  final String authorNickname;
  @JsonKey(name: 'title', defaultValue: '')
  final String title;
  @JsonKey(name: 'content', defaultValue: '')
  final String content;
  @JsonKey(name: 'subject', unknownEnumValue: PostSubjectEnDTO.normal, defaultValue: PostSubjectEnDTO.normal)
  final PostSubjectEnDTO subject;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'likes', defaultValue: 0)
  final int likeCount;
  @JsonKey(name: 'comment_count', defaultValue: 0)
  final int commentCount;
  @JsonKey(name: 'view_cnt', defaultValue: 0)
  final int viewCount;

  factory SearchPostDTO.fromJson(Map<String, dynamic> json) => _$SearchPostDTOFromJson(json);

  const SearchPostDTO({
    required this.id,
    required this.authorNickname,
    required this.title,
    required this.content,
    required this.subject,
    required this.createdAt,
    required this.imageUrl,
    required this.likeCount,
    required this.commentCount,
    required this.viewCount,
  });
}
