import 'package:brew_buds/common/extension/string_ext.dart';
import 'package:brew_buds/data/dto/common/coffee_life_dto.dart';
import 'package:brew_buds/data/dto/common/preferred_bean_taste_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_dto.g.dart';

@JsonSerializable(createToJson: false)
class ProfileDTO {
  final int id;
  final String nickname;
  @JsonKey(name: 'profile_image', defaultValue: '')
  final String profileImageUrl;
  @JsonKey(defaultValue: null)
  final String? introduction;
  @JsonKey(name: 'profile_link', defaultValue: null)
  final String? profileLink;
  @JsonKey(name: 'coffee_life', fromJson: _coffeeLifeFromJson)
  final List<CoffeeLifeDTO> coffeeLife;
  @JsonKey(name: 'preferred_bean_taste', fromJson: _preferredBeanTasteFromJson)
  final PreferredBeanTasteDTO preferredBeanTaste;
  @JsonKey(name: 'is_certificated', defaultValue: null)
  final bool? isCertificated;
  @JsonKey(name: 'following_cnt', defaultValue: 0)
  final int followingCount;
  @JsonKey(name: 'follower_cnt', defaultValue: 0)
  final int followerCount;
  @JsonKey(name: 'tasted_record_cnt', defaultValue: 0)
  final int tastedRecordCnt;
  @JsonKey(name: 'is_user_following', defaultValue: false)
  final bool isUserFollowing;
  @JsonKey(name: 'is_user_blocking', defaultValue: false)
  final bool isUserBlocking;

  factory ProfileDTO.fromJson(Map<String, dynamic> json) => _$ProfileDTOFromJson(json);

  const ProfileDTO({
    required this.id,
    required this.nickname,
    required this.profileImageUrl,
    this.introduction,
    this.profileLink,
    required this.coffeeLife,
    required this.preferredBeanTaste,
    this.isCertificated,
    required this.followingCount,
    required this.followerCount,
    required this.tastedRecordCnt,
    required this.isUserFollowing,
    required this.isUserBlocking,
  });
}

List<CoffeeLifeDTO> _coffeeLifeFromJson(Map<String, dynamic>? json) {
  if (json != null) {
    final List<CoffeeLifeDTO> coffeeLife = [];
    if ((json['cafe_alba'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.cafeAlba);
    }
    if ((json['cafe_tour'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.cafeTour);
    }
    if ((json['cafe_work'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.cafeWork);
    }
    if ((json['coffee_study'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.coffeeStudy);
    }
    if ((json['cafe_operation'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.cafeOperation);
    }
    if ((json['coffee_extraction'] as bool?) ?? false) {
      coffeeLife.add(CoffeeLifeDTO.coffeeExtraction);
    }
    return coffeeLife;
  } else {
    return [];
  }
}

PreferredBeanTasteDTO _preferredBeanTasteFromJson(dynamic json) {
  if (json != null) {
    if (json is Map<String, dynamic>) {
      return PreferredBeanTasteDTO.fromJson(json);
    } else if (json is String) {
      return PreferredBeanTasteDTO.fromJson(json.convertToJson());
    } else {
      return PreferredBeanTasteDTO.empty();
    }
  } else {
    return PreferredBeanTasteDTO.empty();
  }
}
