enum BeanWriteOption {
  area,
  variety,
  processing,
  roastingPoint,
  roastery,
  extraction,
  beverageType;

  @override
  String toString() {
    switch (this) {
      case BeanWriteOption.area:
        return '생산 지역';
      case BeanWriteOption.variety:
        return '품종';
      case BeanWriteOption.processing:
        return '가공방식';
      case BeanWriteOption.roastingPoint:
        return '로스팅 포인트';
      case BeanWriteOption.roastery:
        return '로스터리';
      case BeanWriteOption.extraction:
        return '추출방식';
      case BeanWriteOption.beverageType:
        return '음료 유형';
    }
  }
}
