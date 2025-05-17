import 'package:json_annotation/json_annotation.dart';

part 'blocked_user.g.dart';

@JsonSerializable(createToJson: false)
class BlockedUser {
  final int id;
  @JsonKey(name: 'profile_image', defaultValue: '')
  final String profileImageUrl;
  final String nickname;

  factory BlockedUser.fromJson(Map<String, dynamic> json) => _$BlockedUserFromJson(json);

  BlockedUser({
    required this.id,
    required this.profileImageUrl,
    required this.nickname,
  });

  BlockedUser copyWith({
    int? id,
    String? profileImageUrl,
    String? nickname,
    bool? isBlocked,
  }) {
    return BlockedUser(
      id: id ?? this.id,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nickname: nickname ?? this.nickname,
    );
  }
}
