enum BeanType {
  singleOrigin,
  blend;

  @override
  String toString() => switch (this) {
    BeanType.singleOrigin => '싱글오리진',
    BeanType.blend => '블렌드',
  };
}
