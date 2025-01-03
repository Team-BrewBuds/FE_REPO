import 'package:json_annotation/json_annotation.dart';

enum Gender {
  @JsonValue('남')
  male,
  @JsonValue('여')
  female;

  String toString() => switch (this) {
        Gender.male => '남성',
        Gender.female => '여성',
      };
}
