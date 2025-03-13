import 'package:brew_buds/model/post/post_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'post_in_profile.g.dart';

@JsonSerializable(createToJson: false)
class PostInProfile {
  final int id;
  final String author;
  final PostSubject subject;
  final String title;
  @JsonKey(name: 'created_at')
  final String createdAt;
  @JsonKey(name: 'represent_post_photo')
  final String? imageUri;
  @JsonKey(name: 'tasted_records_photo')
  final String? tastedRecordImageUri;

  PostInProfile(
    this.id,
    this.author,
    this.subject,
    this.title,
    this.createdAt,
    this.imageUri,
    this.tastedRecordImageUri,
  );

  factory PostInProfile.fromJson(Map<String, dynamic> json) => _$PostInProfileFromJson(json);
}