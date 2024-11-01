import 'package:json_annotation/json_annotation.dart';

enum PostSubject {
  @JsonValue('bean')
  beans,
  @JsonValue('question')
  question,
  @JsonValue('normal')
  normal,
  @JsonValue('cafe')
  caffe,
  @JsonValue('worry')
  worry,
  @JsonValue('info')
  information;

  @override
  String toString() => switch (this) {
    PostSubject.beans => '원두',
    PostSubject.question => '질문',
    PostSubject.normal => '일반',
    PostSubject.caffe => '카페',
    PostSubject.worry => '고민',
    PostSubject.information => '정보',
  };

  String get iconPath => switch (this){
    PostSubject.beans => 'assets/icons/coffee_bean.svg',
    PostSubject.question => 'assets/icons/home_question.svg',
    PostSubject.normal => 'assets/icons/home_normal.svg',
    PostSubject.caffe => 'assets/icons/home_caffe.svg',
    PostSubject.worry => 'assets/icons/home_worry.svg',
    PostSubject.information => 'assets/icons/home_information.svg',
  };
}
