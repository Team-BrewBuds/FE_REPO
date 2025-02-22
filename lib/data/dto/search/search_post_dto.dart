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
  @JsonKey(name: 'subject', defaultValue: '')
  final String subject;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'photos', defaultValue: '')
  final String imageUrl;
  @JsonKey(name: 'like_cnt', defaultValue: 0)
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
