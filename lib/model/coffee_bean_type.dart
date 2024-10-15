enum CoffeeBeanType {
  singleOrigin,
  blend;

  @override
  String toString() => switch (this) {
    CoffeeBeanType.singleOrigin => '싱글 오리진',
    CoffeeBeanType.blend => '블렌드',
  };
}