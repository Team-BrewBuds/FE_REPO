enum ProfileSortCriteria {
  createdAt,
  tastedReviewStar,
  avgStar,
  noteCreatedAt,
  tastedRecordsCnt;

  static List<ProfileSortCriteria> tastedRecord() => [
        ProfileSortCriteria.createdAt,
        ProfileSortCriteria.tastedReviewStar,
      ];

  static List<ProfileSortCriteria> notedCoffeeBean() => [
        ProfileSortCriteria.noteCreatedAt,
        ProfileSortCriteria.avgStar,
        ProfileSortCriteria.tastedRecordsCnt,
      ];

  @override
  String toString() => switch (this) {
        ProfileSortCriteria.createdAt => '최신순',
        ProfileSortCriteria.tastedReviewStar => '별점 높은 순',
        ProfileSortCriteria.noteCreatedAt => '최근 찜한 순',
        ProfileSortCriteria.avgStar => '평균 별점 높은 순',
        ProfileSortCriteria.tastedRecordsCnt => '기록 많은 순',
      };

  String toJson() => switch (this) {
        ProfileSortCriteria.createdAt => 'created_at',
        ProfileSortCriteria.tastedReviewStar => 'taste_review__star',
        ProfileSortCriteria.noteCreatedAt => 'note__created_at',
        ProfileSortCriteria.avgStar => 'avg_star',
        ProfileSortCriteria.tastedRecordsCnt => 'tasted_records_cnt',
      };
}
