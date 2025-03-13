enum SortCriteria {
  rating,
  upToDate,
  like,
  follower,
  tastingRecords;

  @override
  String toString() => switch (this) {
        SortCriteria.upToDate => '최신순',
        SortCriteria.rating => '별점 높은 순',
        SortCriteria.tastingRecords => '시음 기록 많은 순',
        SortCriteria.like => '좋아요 많은 순',
        SortCriteria.follower => '팔로워 많은 순',
      };

  static List<SortCriteria> coffeeBean() => [
        SortCriteria.rating,
        SortCriteria.tastingRecords,
      ];

  static List<SortCriteria> buddy() => [
        SortCriteria.follower,
        SortCriteria.tastingRecords,
      ];

  static List<SortCriteria> tastedRecord() => [
        SortCriteria.upToDate,
        SortCriteria.like,
        SortCriteria.rating,
      ];

  static List<SortCriteria> post() => [
        SortCriteria.upToDate,
        SortCriteria.like,
      ];

  String toJson() => switch(this) {
    SortCriteria.rating => 'avg_star',
    SortCriteria.upToDate => 'latest',
    SortCriteria.like => 'like_rank',
    SortCriteria.follower => 'follower_cnt',
    SortCriteria.tastingRecords => 'record_count',
  };
}
