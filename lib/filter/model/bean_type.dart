import 'package:json_annotation/json_annotation.dart';

enum BeanType {
  @JsonValue('single')
  singleOrigin,
  @JsonValue('blend')
  blend;

  @override
  String toString() => switch (this) {
    BeanType.singleOrigin => '싱글오리진',
    BeanType.blend => '블렌드',
  };
}
