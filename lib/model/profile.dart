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
    @JsonKey(name:'coffee_life') required Map<String,dynamic>  coffLife,
    @JsonKey(name:'following_cnt')  int ?followingCnt,
    @JsonKey(name:'follower_cnt') int ?followerCnt,
    @JsonKey(name: 'post_cnt')  int ?postCnt,
    @JsonKey(defaultValue: false) required bool isUserFollowing,
    @JsonKey(defaultValue: false) required bool isUserBlocking


  }) = _Profile;


  factory Profile.fromJson(Map<String, Object?> json) => _$ProfileFromJson(json);





}