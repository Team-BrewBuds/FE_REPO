enum SearchSortCriteria {
  recordCount,
  recordCountBuddy,
  avgStar,
  followerCnt,
  latest,
  likeRank,
  starRank;

  static List<SearchSortCriteria> coffeeBean() => [
        SearchSortCriteria.avgStar,
        SearchSortCriteria.recordCount,
      ];

  static List<SearchSortCriteria> buddy() => [
        SearchSortCriteria.followerCnt,
        SearchSortCriteria.recordCountBuddy,
      ];

  static List<SearchSortCriteria> tastedRecord() => [
        SearchSortCriteria.latest,
        SearchSortCriteria.likeRank,
        SearchSortCriteria.starRank,
      ];

  static List<SearchSortCriteria> post() => [
        SearchSortCriteria.latest,
        SearchSortCriteria.likeRank,
      ];

  @override
  String toString() => switch (this) {
        SearchSortCriteria.avgStar => '별점 높은 순',
        SearchSortCriteria.recordCount => '시음기록 많은 순',
        SearchSortCriteria.recordCountBuddy => '시음기록 많은 순',
        SearchSortCriteria.followerCnt => '팔로워 많은 순',
        SearchSortCriteria.latest => '최신순',
        SearchSortCriteria.likeRank => '좋아요 많은 순',
        SearchSortCriteria.starRank => '별점 높은 순',
      };

  String toJson() => switch (this) {
        SearchSortCriteria.recordCount => 'record_count',
        SearchSortCriteria.recordCountBuddy => 'record_cnt',
        SearchSortCriteria.avgStar => 'avg_star',
        SearchSortCriteria.followerCnt => 'follower_cnt',
        SearchSortCriteria.latest => 'latest',
        SearchSortCriteria.likeRank => 'like_rank',
        SearchSortCriteria.starRank => 'star_rank',
      };
}
