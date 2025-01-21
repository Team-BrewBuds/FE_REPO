enum SearchSortCriteria {
  rating,
  upToDate,
  like,
  follower,
  tastingRecords;

  @override
  String toString() => switch (this) {
        SearchSortCriteria.upToDate => '최신순',
        SearchSortCriteria.rating => '별점 높은 순',
        SearchSortCriteria.tastingRecords => '시음 기록 많은 순',
        SearchSortCriteria.like => '좋아요 많은 순',
        SearchSortCriteria.follower => '팔로워 많은 순',
      };

  static List<SearchSortCriteria> coffeeBean() => [
        SearchSortCriteria.rating,
        SearchSortCriteria.tastingRecords,
      ];

  static List<SearchSortCriteria> buddy() => [
        SearchSortCriteria.follower,
        SearchSortCriteria.tastingRecords,
      ];

  static List<SearchSortCriteria> tastedRecord() => [
        SearchSortCriteria.upToDate,
        SearchSortCriteria.like,
        SearchSortCriteria.rating,
      ];

  static List<SearchSortCriteria> post() => [
        SearchSortCriteria.upToDate,
        SearchSortCriteria.like,
      ];
}
