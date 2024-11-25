import 'package:brew_buds/model/profile_detail.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'profile.freezed.dart';

part 'profile.g.dart';

@freezed
class Profile with _$Profile {
  const factory Profile({
    @JsonKey() required String nickname,
    @JsonKey(name: 'profile_image', defaultValue: '') String? profileImageUri,
    @JsonKey() String ? introduction,
    @JsonKey() String ? profile_link,
    @JsonKey()  Map<String,Map<String,dynamic>>? coffLife,
    @JsonKey(defaultValue: 0)  int ?followingCnt,
    @JsonKey(defaultValue: 0) int ?followerCnt,
    @JsonKey(defaultValue: 0)  int ?postCnt,
    @JsonKey(defaultValue: false) required bool isUserFollowing,
    @JsonKey(defaultValue: false) required bool isUserBlocking


  }) = _Profile;


  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);





}