enum PostTag {
  beans,
  question,
  normal,
  caffe,
  worry,
  information;

  @override
  String toString() => switch (this) {
    PostTag.beans => '원두',
    PostTag.question => '질문',
    PostTag.normal => '일반',
    PostTag.caffe => '카페',
    PostTag.worry => '고민',
    PostTag.information => '정보',
  };

  String get iconPath => switch (this){
    PostTag.beans => 'assets/icons/coffee_bean.svg',
    PostTag.question => 'assets/icons/home_question.svg',
    PostTag.normal => 'assets/icons/home_normal.svg',
    PostTag.caffe => 'assets/icons/home_caffe.svg',
    PostTag.worry => 'assets/icons/home_worry.svg',
    PostTag.information => 'assets/icons/home_information.svg',
  };
}
