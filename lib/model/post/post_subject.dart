enum PostSubject {
  all,
  normal,
  caffe,
  beans,
  information,
  gear,
  question,
  worry;

  @override
  String toString() => switch (this) {
        PostSubject.all => '전체',
        PostSubject.beans => '원두',
        PostSubject.question => '질문',
        PostSubject.normal => '일반',
        PostSubject.caffe => '카페',
        PostSubject.worry => '고민',
        PostSubject.information => '정보',
        PostSubject.gear => '장비',
      };

  String get iconPath => switch (this) {
        PostSubject.all => '',
        PostSubject.beans => 'assets/icons/subject_coffee_bean.svg',
        PostSubject.question => 'assets/icons/subject_question.svg',
        PostSubject.normal => 'assets/icons/subject_normal.svg',
        PostSubject.caffe => 'assets/icons/subject_caffee.svg',
        PostSubject.worry => 'assets/icons/subject_worry.svg',
        PostSubject.information => 'assets/icons/subject_info.svg',
        PostSubject.gear => 'assets/icons/gear.svg',
      };

  String? toJsonValue() => switch (this) {
        PostSubject.all => null,
        PostSubject.beans => 'bean',
        PostSubject.question => 'question',
        PostSubject.normal => 'normal',
        PostSubject.caffe => 'cafe',
        PostSubject.worry => 'worry',
        PostSubject.information => 'info',
        PostSubject.gear => 'gear',
      };
}
