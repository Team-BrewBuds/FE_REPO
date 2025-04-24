sealed class SearchResultModel {
  factory SearchResultModel.coffeeBean({
    required int id,
    required String name,
    required double rating,
    required int recordedCount,
    required String imageUrl,
  }) = CoffeeBeanSearchResultModel;

  factory SearchResultModel.buddy({
    required int id,
    required String profileImageUrl,
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
    required String imageUrl,
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
    required String imageUrl,
  }) = PostSearchResultModel;
}

class CoffeeBeanSearchResultModel implements SearchResultModel {
  final int id;
  final String name;
  final double rating;
  final int recordedCount;
  final String imageUrl;

  const CoffeeBeanSearchResultModel({
    required this.id,
    required this.name,
    required this.rating,
    required this.recordedCount,
    required this.imageUrl,
  });
}

class BuddySearchResultModel implements SearchResultModel {
  final int id;
  final String profileImageUrl;
  final String nickname;
  final int followerCount;
  final int tastedRecordsCount;

  const BuddySearchResultModel({
    required this.id,
    required this.profileImageUrl,
    required this.nickname,
    required this.followerCount,
    required this.tastedRecordsCount,
  });

  BuddySearchResultModel copyWith({
    String? profileImageUrl,
    String? nickname,
    int? followerCount,
    int? tastedRecordsCount,
  }) {
    return BuddySearchResultModel(
      id: id,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      nickname: nickname ?? this.nickname,
      followerCount: followerCount ?? this.followerCount,
      tastedRecordsCount: tastedRecordsCount ?? this.tastedRecordsCount,
    );
  }
}

class TastedRecordSearchResultModel implements SearchResultModel {
  final int id;
  final String title;
  final double rating;
  final String beanType;
  final List<String> taste;
  final String contents;
  final String imageUrl;

  const TastedRecordSearchResultModel({
    required this.id,
    required this.title,
    required this.rating,
    required this.beanType,
    required this.taste,
    required this.contents,
    required this.imageUrl,
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
  final String imageUrl;

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
    required this.imageUrl,
  });

  PostSearchResultModel copyWith({
    String? title,
    String? contents,
    int? likeCount,
    int? commentCount,
    int? hits,
    String? createdAt,
    String? authorNickname,
    String? subject,
    String? imageUrl,
  }) {
    return PostSearchResultModel(
      id: id,
      title: title ?? this.title,
      contents: contents ?? this.contents,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      hits: hits ?? this.hits,
      createdAt: createdAt ?? this.createdAt,
      authorNickname: authorNickname ?? this.authorNickname,
      subject: subject ?? this.subject,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
