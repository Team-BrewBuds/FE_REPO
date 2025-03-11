enum BeverageType {
  hot,
  ice;

  @override
  String toString() {
    switch (this) {
      case BeverageType.ice:
        return '아이스';
      case BeverageType.hot:
        return '핫';
    }
  }
}
