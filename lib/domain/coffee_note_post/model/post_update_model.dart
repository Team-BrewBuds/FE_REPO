import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/model/post/post_subject.dart';

final class PostUpdateModel {
  final String title;
  final String contents;
  final PostSubject subject;
  final String tag;

  const PostUpdateModel({
    required this.title,
    required this.contents,
    required this.subject,
    required this.tag,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'content': contents,
      'subject': subject.toJson(),
    };

    if (tag.isNotEmpty) {
      json['tag'] = tag;
    }

    return json;
  }
}
