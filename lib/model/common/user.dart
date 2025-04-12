import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String nickname,
    required String profileImageUrl,
  }) = _User;
}
