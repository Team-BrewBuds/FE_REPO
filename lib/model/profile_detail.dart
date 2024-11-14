

import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_detail.freezed.dart';
part 'profile_detail.g.dart';

@freezed
class ProfileDetail with _$ProfileDetail {
  const factory ProfileDetail({
    @JsonKey() String ? introduction,
    @JsonKey() String? profileLink,
    @JsonKey() Map<String,Map<String,dynamic>> ?coffeeLife,
    @JsonKey() String ? preferredBeanTaste,
    @JsonKey() bool ? isCertificated,

}) = _ProfileDetail;

factory ProfileDetail.fromJson(Map<String, Object?> json) => _$ProfileDetailFromJson(json);
}