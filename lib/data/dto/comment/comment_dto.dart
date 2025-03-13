import 'package:brew_buds/data/dto/user/user_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'comment_dto.g.dart';

@JsonSerializable(createToJson: false)
class CommentDTO {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: UserDTO.defaultUser)
  final UserDTO author;
  @JsonKey(defaultValue: '')
  final String content;
  @JsonKey(name: 'likes', defaultValue: 0)
  final int likeCount;
  @JsonKey(name: 'created_at', defaultValue: '')
  final String createdAt;
  @JsonKey(name: 'replies', defaultValue: [])
  final List<CommentDTO> reComments;
  @JsonKey(name: 'is_user_liked', defaultValue: false)
  final bool isLiked;
  @JsonKey(name: 'parent', defaultValue: null)
  final int? parentId;

  factory CommentDTO.fromJson(Map<String, dynamic> json) => _$CommentDTOFromJson(json);

  const CommentDTO({
    required this.id,
    required this.author,
    required this.content,
    required this.likeCount,
    required this.createdAt,
    required this.reComments,
    required this.isLiked,
    this.parentId,
  });
}
