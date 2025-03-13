import 'package:json_annotation/json_annotation.dart';
import 'package:intl/intl.dart';

part 'taste_review.g.dart';

@JsonSerializable(explicitToJson: true)
class TasteReview {
  final String flavor;
  final int body;
  final int acidity;
  final int bitterness;
  final int sweetness;
  final double star;
  @JsonKey(name: 'tasted_at', toJson: _tastedAtToJson, includeIfNull: false)
  final DateTime? tastedAt;
  @JsonKey()
  final String place;

  Map<String, dynamic> toJson() => _$TasteReviewToJson(this);

  const TasteReview({
    required this.flavor,
    required this.body,
    required this.acidity,
    required this.bitterness,
    required this.sweetness,
    required this.star,
    required this.tastedAt,
    required this.place,
  });

  factory TasteReview.initial() => const TasteReview(
        flavor: '',
        body: 0,
        acidity: 0,
        bitterness: 0,
        sweetness: 0,
        star: 0,
        tastedAt: null,
        place: '',
      );

  TasteReview copyWith({
    String? flavor,
    int? body,
    int? acidity,
    int? bitterness,
    int? sweetness,
    double? star,
    DateTime? tastedAt,
    String? place,
  }) {
    return TasteReview(
      flavor: flavor ?? this.flavor,
      body: body ?? this.body,
      acidity: acidity ?? this.acidity,
      bitterness: bitterness ?? this.bitterness,
      sweetness: sweetness ?? this.sweetness,
      star: star ?? this.star,
      tastedAt: tastedAt ?? this.tastedAt,
      place: place ?? this.place,
    );
  }
}

String _tastedAtToJson(DateTime? tastedAt) {
  return DateFormat('yyyy-MM-dd').format(tastedAt ?? DateTime.now());
}

String? _nullableStringToJson(String? text) => (text ?? '').isEmpty ? null : text;