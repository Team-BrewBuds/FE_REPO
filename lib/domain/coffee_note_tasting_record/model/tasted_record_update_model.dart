import 'package:brew_buds/data/mapper/tasted_record/taste_review_mapper.dart';
import 'package:brew_buds/model/tasted_record/tasted_review.dart';

final class TastedRecordUpdateModel {
  final String contents;
  final String tag;
  final TasteReview tasteReview;

  const TastedRecordUpdateModel({
    required this.contents,
    required this.tag,
    required this.tasteReview,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'content': contents,
      'taste_review': tasteReview.toJson(),
    };

    if (tag.isNotEmpty) {
      json['tag'] = tag;
    }

    return json;
  }
}
