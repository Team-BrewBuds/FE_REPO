import 'package:json_annotation/json_annotation.dart';

part 'preferred_bean_taste.g.dart';

@JsonSerializable(createFactory: false)
final class PreferredBeanTaste {
  @JsonKey(name: 'body') final int? body;
  @JsonKey(name: 'acidity') final int? acidity;
  @JsonKey(name: 'bitterness') final int? bitterness;
  @JsonKey(name: 'sweetness') final int? sweetness;

  const PreferredBeanTaste({
    this.body,
    this.acidity,
    this.bitterness,
    this.sweetness,
  });

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
