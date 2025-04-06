import 'package:json_annotation/json_annotation.dart';

part 'taste_review_dto.g.dart';

@JsonSerializable(createToJson: false)
class TasteReviewDTO {
  @JsonKey(name: 'tasted_at', defaultValue: '')
  final String tastedAt;
  @JsonKey(name: 'flavor', defaultValue: [], fromJson: _flavorFromJson)
  final List<String> flavors;
  @JsonKey(defaultValue: '')
  final String place;
  @JsonKey(defaultValue: 0)
  final int body;
  @JsonKey(defaultValue: 0)
  final int acidity;
  @JsonKey(defaultValue: 0)
  final int bitterness;
  @JsonKey(defaultValue: 0)
  final int sweetness;
  @JsonKey(defaultValue: 0.0)
  final double star;

  factory TasteReviewDTO.fromJson(Map<String, dynamic> json) => _$TasteReviewDTOFromJson(json);

  static TasteReviewDTO defaultTasteReview() => const TasteReviewDTO(
        tastedAt: '',
        flavors: [],
        place: '',
        body: 0,
        acidity: 0,
        bitterness: 0,
        sweetness: 0,
        star: 0.0,
      );

  const TasteReviewDTO({
    required this.tastedAt,
    required this.flavors,
    required this.place,
    required this.body,
    required this.acidity,
    required this.bitterness,
    required this.sweetness,
    required this.star,
  });
}

List<String> _flavorFromJson(String jsonData) => jsonData.split(',');
