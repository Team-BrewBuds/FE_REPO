import 'package:json_annotation/json_annotation.dart';

part 'tasting_record_in_profile.g.dart';

@JsonSerializable(createToJson: false)
class TastingRecordInProfile {
  final int id;
  @JsonKey(name: 'bean_name')
  final String beanName;
  @JsonKey(name: 'star')
  final double rating;
  @JsonKey(name: 'photo_url', defaultValue: '')
  final String imageUri;
  @JsonKey(name: 'likes')
  final int likeCount;

  TastingRecordInProfile(
    this.id,
    this.beanName,
    this.rating,
    this.imageUri,
    this.likeCount,
  );

  factory TastingRecordInProfile.fromJson(Map<String, dynamic> json) => _$TastingRecordInProfileFromJson(json);
}
