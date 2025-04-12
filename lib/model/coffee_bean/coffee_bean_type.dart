import 'package:json_annotation/json_annotation.dart';

enum CoffeeBeanType {
  @JsonValue('single')
  singleOrigin,
  @JsonValue('blend')
  blend;

  @override
  String toString() => switch (this) {
        CoffeeBeanType.singleOrigin => '싱글오리진',
        CoffeeBeanType.blend => '블렌드',
      };
}
