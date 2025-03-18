import 'package:brew_buds/data/dto/post/post_subject_dto.dart';
import 'package:brew_buds/data/dto/post/post_subject_en_dto.dart';
import 'package:brew_buds/model/post/post_subject.dart';

extension PostSubjectMapper on PostSubjectDTO {
  PostSubject toDomain() {
    switch (this) {
      case PostSubjectDTO.normal:
        return PostSubject.normal;
      case PostSubjectDTO.caffe:
        return PostSubject.caffe;
      case PostSubjectDTO.beans:
        return PostSubject.beans;
      case PostSubjectDTO.information:
        return PostSubject.information;
      case PostSubjectDTO.gear:
        return PostSubject.gear;
      case PostSubjectDTO.question:
        return PostSubject.question;
      case PostSubjectDTO.worry:
        return PostSubject.worry;
    }
  }
}

extension PostSubjectEnMapper on PostSubjectEnDTO {
  PostSubject toDomain() {
    switch (this) {
      case PostSubjectEnDTO.normal:
        return PostSubject.normal;
      case PostSubjectEnDTO.cafe:
        return PostSubject.caffe;
      case PostSubjectEnDTO.bean:
        return PostSubject.beans;
      case PostSubjectEnDTO.info:
        return PostSubject.information;
      case PostSubjectEnDTO.gear:
        return PostSubject.gear;
      case PostSubjectEnDTO.question:
        return PostSubject.question;
      case PostSubjectEnDTO.worry:
        return PostSubject.worry;
    }
  }
}

extension PostSubjectToJson on PostSubject {
  String? toJson() => switch (this) {
    PostSubject.all => null,
    PostSubject.beans => 'bean',
    PostSubject.question => 'question',
    PostSubject.normal => 'normal',
    PostSubject.caffe => 'cafe',
    PostSubject.worry => 'worry',
    PostSubject.information => 'info',
    PostSubject.gear => 'gear',
  };
}
