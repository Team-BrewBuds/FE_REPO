import 'package:json_annotation/json_annotation.dart';

enum PostSubject {
  @JsonValue('전체')
  all,
  @JsonValue('일반')
  normal,
  @JsonValue('카페')
  caffe,
  @JsonValue('원두')
  beans,
  @JsonValue('정보')
  information,
  @JsonValue('질문')
  question,
  @JsonValue('고민')
  worry,
  @JsonValue('장비')
  gear;

  @override
  String toString() => switch (this) {
    PostSubject.all => '전체',
    PostSubject.beans => '원두',
    PostSubject.question => '질문',
    PostSubject.normal => '일반',
    PostSubject.caffe => '카페',
    PostSubject.worry => '고민',
    PostSubject.information => '정보',
    PostSubject.gear => '장비',
  };

  String get iconPath => switch (this){
    PostSubject.all => '',
    PostSubject.beans => 'assets/icons/coffee_bean.svg',
    PostSubject.question => 'assets/icons/home_question.svg',
    PostSubject.normal => 'assets/icons/home_normal.svg',
    PostSubject.caffe => 'assets/icons/home_caffe.svg',
    PostSubject.worry => 'assets/icons/home_worry.svg',
    PostSubject.information => 'assets/icons/home_information.svg',
    PostSubject.gear => 'assets/icons/gear.svg',
  };

  String? toJsonValue() => switch (this) {
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
