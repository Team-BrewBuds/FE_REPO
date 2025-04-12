import 'package:json_annotation/json_annotation.dart';

enum PostSubjectDTO {
  @JsonValue('일반')
  normal,
  @JsonValue('카페')
  caffe,
  @JsonValue('원두')
  beans,
  @JsonValue('정보')
  information,
  @JsonValue('장비')
  gear,
  @JsonValue('질문')
  question,
  @JsonValue('고민')
  worry;
}
