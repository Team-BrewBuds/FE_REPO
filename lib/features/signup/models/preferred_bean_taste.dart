import 'package:json_annotation/json_annotation.dart';

part 'preferred_bean_taste.g.dart';

@JsonSerializable(includeIfNull: false)
final class PreferredBeanTaste {
  @JsonKey(defaultValue: 0) final int body;
  @JsonKey(defaultValue: 0) final int acidity;
  @JsonKey(defaultValue: 0) final int bitterness;
  @JsonKey(defaultValue: 0) final int sweetness;

  const PreferredBeanTaste({
    this.body = 0,
    this.acidity = 0,
    this.bitterness = 0,
    this.sweetness = 0,
  });

  factory PreferredBeanTaste.init() => const PreferredBeanTaste(body: 0, acidity: 0, bitterness: 0, sweetness: 0);

  factory PreferredBeanTaste.fromJson(Map<String, dynamic> json) => _$PreferredBeanTasteFromJson(json);

  Map<String, dynamic> toJson() => _$PreferredBeanTasteToJson(this);

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
