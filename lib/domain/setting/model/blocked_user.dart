import 'package:json_annotation/json_annotation.dart';

part 'blocked_user.g.dart';

@JsonSerializable(createToJson: false)
class BlockedUser {
  final int id;
  @JsonKey(name: 'profile_image', defaultValue: '')
  final String profileImageUri;
  final String nickname;

  factory BlockedUser.fromJson(Map<String, dynamic> json) => _$BlockedUserFromJson(json);

  BlockedUser({
    required this.id,
    required this.profileImageUri,
    required this.nickname,
  });

  BlockedUser copyWith({
    int? id,
    String? profileImageUri,
    String? nickname,
    bool? isBlocked,
  }) {
    return BlockedUser(
      id: id ?? this.id,
      profileImageUri: profileImageUri ?? this.profileImageUri,
      nickname: nickname ?? this.nickname,
    );
  }
}
