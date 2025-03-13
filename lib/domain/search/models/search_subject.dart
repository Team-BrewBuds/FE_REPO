enum SearchSubject {
  coffeeBean,
  buddy,
  tastedRecord,
  post;

  @override
  String toString() => switch (this) {
        SearchSubject.coffeeBean => '원두정보',
        SearchSubject.buddy => '버디',
        SearchSubject.tastedRecord => '시음기록',
        SearchSubject.post => '게시글',
      };
}
