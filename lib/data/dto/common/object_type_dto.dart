import 'package:json_annotation/json_annotation.dart';

enum ObjectTypeDTO {
  @JsonValue('게시물')
  post,
  @JsonValue('시음기록')
  tastedRecord,
}
