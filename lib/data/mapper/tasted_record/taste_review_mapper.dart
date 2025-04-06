import 'package:brew_buds/data/dto/tasted_record/taste_review_dto.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';

extension TasteReviewMapper on TasteReviewDTO {
  TasteReview toDomain() {
    return TasteReview(
      tastedAt: tastedAt,
      flavors: flavors,
      place: place,
      body: body,
      acidity: acidity,
      bitterness: bitterness,
      sweetness: sweetness,
      star: star,
    );
  }
}

extension TastedReviewToJson on TasteReview {
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'flavor': flavors.join(','),
      'body': body,
      'acidity': acidity,
      'bitterness': bitterness,
      'sweetness': sweetness,
      'star': star,
      'tasted_at': tastedAt,
    };
    if (place.isNotEmpty) {
      json['place'] = place;
    }
    return json;
  }
}