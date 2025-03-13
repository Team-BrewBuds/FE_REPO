import 'package:brew_buds/domain/profile/model/saved_note/saved_note.dart';
import 'package:brew_buds/model/post/post_subject.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_post.g.dart';

@JsonSerializable(createToJson: false)
class SavedPost with SavedNote {
  @JsonKey(name: 'post_id')
  final int id;
  @JsonKey(name: 'nickname')
  final String author;
  @JsonKey(fromJson: _subjectFromJson)
  final PostSubject subject;
  final String title;
  @JsonKey(name: 'created_at', fromJson: _createdAtFromJson)
  final String createdAt;
  @JsonKey(name: 'photo_url')
  final String? imageUri;

  SavedPost(
    this.id,
    this.author,
    this.subject,
    this.title,
    this.createdAt,
    this.imageUri,
  );

  factory SavedPost.fromJson(Map<String, dynamic> json) => _$SavedPostFromJson(json);
}

PostSubject _subjectFromJson(String json) {
  if (json == 'all') {
    return PostSubject.all;
  } else if (json == 'normal') {
    return PostSubject.normal;
  } else if (json == 'caffe') {
    return PostSubject.caffe;
  } else if (json == 'beans') {
    return PostSubject.beans;
  } else if (json == 'information') {
    return PostSubject.information;
  } else if (json == 'gear') {
    return PostSubject.gear;
  } else if (json == 'question') {
    return PostSubject.question;
  } else {
    return PostSubject.worry;
  }
}

String _createdAtFromJson(String json) {
  final date = DateTime.tryParse(json);
  if (date != null) {
    return '${date.month}/${date.day}';
  } else {
    return '';
  }
}