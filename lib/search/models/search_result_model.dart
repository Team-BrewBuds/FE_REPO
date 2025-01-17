sealed class SearchResultModel {
  factory SearchResultModel.coffeeBean({
    required int id,
    required String name,
    required double rating,
    required int recordedCount,
  }) = CoffeeBeanSearchResultModel;

  factory SearchResultModel.buddy({
    required int id,
    required String profileImageUri,
    required String nickname,
    required int followerCount,
    required int tastedRecordsCount,
  }) = BuddySearchResultModel;

  factory SearchResultModel.tastedRecord({
    required int id,
    required String title,
    required double rating,
    required String beanType,
    required List<String> taste,
    required String contents,
    required String imageUri,
  }) = TastedRecordSearchResultModel;

  factory SearchResultModel.post({
    required int id,
    required String title,
    required String contents,
    required int likeCount,
    required int commentCount,
    required int hits,
    required String createdAt,
    required String authorNickname,
    required String subject,
    required String imageUri,
  }) = PostSearchResultModel;
}

class CoffeeBeanSearchResultModel implements SearchResultModel {
  final int id;
  final String name;
  final double rating;
  final int recordedCount;

  const CoffeeBeanSearchResultModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.recordedCount,
  });
}

class BuddySearchResultModel implements SearchResultModel {
  final int id;
  final String profileImageUri;
  final String nickname;
  final int followerCount;
  final int tastedRecordsCount;

  const BuddySearchResultModel({
    required this.id,
    required this.profileImageUri,
    required this.nickname,
    required this.followerCount,
    required this.tastedRecordsCount,
  });
}

class TastedRecordSearchResultModel implements SearchResultModel {
  final int id;
  final String title;
  final double rating;
  final String beanType;
  final List<String> taste;
  final String contents;
  final String imageUri;

  const TastedRecordSearchResultModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.beanType,
    required this.taste,
    required this.contents,
    required this.imageUri,
  });
}

class PostSearchResultModel implements SearchResultModel {
  final int id;
  final String title;
  final String contents;
  final int likeCount;
  final int commentCount;
  final int hits;
  final String createdAt;
  final String authorNickname;
  final String subject;
  final String imageUri;

  const PostSearchResultModel({
    required this.id,
    required this.title,
    required this.contents,
    required this.likeCount,
    required this.commentCount,
    required this.hits,
    required this.createdAt,
    required this.authorNickname,
    required this.subject,
    required this.imageUri,
  });
}
