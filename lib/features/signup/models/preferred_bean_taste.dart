import 'package:json_annotation/json_annotation.dart';

part 'preferred_bean_taste.g.dart';

@JsonSerializable(includeIfNull: false)
final class PreferredBeanTaste {
  @JsonKey(defaultValue: null) final int? body;
  @JsonKey(defaultValue: null) final int? acidity;
  @JsonKey(defaultValue: null) final int? bitterness;
  @JsonKey(defaultValue: null) final int? sweetness;

  const PreferredBeanTaste({
    this.body,
    this.acidity,
    this.bitterness,
    this.sweetness,
  });

  Map<String, dynamic> toJson() => _$PreferredBeanTasteToJson(this);

  factory PreferredBeanTaste.fromJson(Map<String, dynamic> json) => _$PreferredBeanTasteFromJson(json);

  PreferredBeanTaste copyWith({
    int? body,
    int? acidity,
    int? bitterness,
    int? sweetness,
  }) {
    return PreferredBeanTaste(
      body: body ?? this.body,
      acidity: acidity ?? this.acidity,
      bitterness: bitterness ?? this.bitterness,
      sweetness: sweetness ?? this.sweetness,
    );
  }
}
