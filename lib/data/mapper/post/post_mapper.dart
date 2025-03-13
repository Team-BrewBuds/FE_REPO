import 'package:brew_buds/data/dto/post/post_dto.dart';
import 'package:brew_buds/data/mapper/post/post_subject_mapper.dart';
import 'package:brew_buds/data/mapper/user/user_mapper.dart';
import 'package:brew_buds/model/post/post.dart';

extension PostDTOMapper on PostDTO {
  Post toDomain() => Post(
      id: id,
      author: author.toDomain(),
      isAuthorFollowing: interaction.isFollowing,
      createdAt: createdAt,
      viewCount: viewCount,
      likeCount: likeCount,
      commentsCount: commentsCount,
      subject: subject.toDomain(),
      title: title,
      contents: contents,
      tag: tag,
      isSaved: interaction.isSaved,
      isLiked: interaction.isLiked,
    );
}

extension PostToJson on Post {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }
    json['title'] = title;
    json['content'] = contents;
    writeNotNull('subject', subject.toJson());
    json['tag'] = tag;
    return json;
  }

  Map<String, dynamic> toJsonWithImages({required List<int> images}) {
    final Map<String, dynamic> json = {};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }
    json['title'] = title;
    json['content'] = contents;
    writeNotNull('subject', subject.toJson());
    json['tag'] = tag;
    json['photos'] = images;
    return json;
  }

  Map<String, dynamic> toJsonWithTastedRecords({required List<int> tastedRecords}) {
    final Map<String, dynamic> json = {};
    void writeNotNull(String key, dynamic value) {
      if (value != null) {
        json[key] = value;
      }
    }
    json['title'] = title;
    json['content'] = contents;
    writeNotNull('subject', subject.toJson());
    json['tag'] = tag;
    json['tasted_records'] = tastedRecords;
    return json;
  }
}
