import 'package:json_annotation/json_annotation.dart';

enum CoffeeBeanTypeDTO {
  @JsonValue('single')
  singleOrigin,
  @JsonValue('blend')
  blend;
}
