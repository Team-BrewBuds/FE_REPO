import 'package:brew_buds/model/user.dart';
import 'package:json_annotation/json_annotation.dart';

part 'follow_user.g.dart';

@JsonSerializable(explicitToJson: true, createToJson: false)
class FollowUser {
  final User user;
  @JsonKey(name: 'is_following')
  final bool isFollowing;

  FollowUser(
    this.user,
    this.isFollowing,
  );

  factory FollowUser.fromJson(Map<String, dynamic> json) => _$FollowUserFromJson(json);

  FollowUser copyWith({
    int? id,
    String? nickname,
    String? profileImageUri,
    bool? isFollowing,
  }) {
    return FollowUser(
      User(
        id: id ?? user.id,
        nickname: nickname ?? user.nickname,
        profileImageUri: profileImageUri ?? user.profileImageUri,
      ),
      isFollowing ?? this.isFollowing,
    );
  }
}
