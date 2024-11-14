enum SortCriteria {
  upToDate,
  rating,
  tastingRecords;

  String get buttonString => switch (this) {
    SortCriteria.upToDate => '최근저장순',
    SortCriteria.rating => '별점높은순',
    SortCriteria.tastingRecords => '시음기록순',
  };

  String get columnString => switch (this) {
    SortCriteria.upToDate => '최근 찜한 순',
    SortCriteria.rating => '평균 별점 높은 순',
    SortCriteria.tastingRecords => '시음 기록 많은 순',
  };
}