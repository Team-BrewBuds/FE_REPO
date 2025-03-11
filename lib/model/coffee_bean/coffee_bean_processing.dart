enum CoffeeBeanProcessing {
  natural,
  washed,
  washedFermented,
  honey,
  sugarCane,
  anaerobicFermentation,
  mountainWater,
  writtenByUser;

  @override
  String toString() {
    switch (this) {
      case CoffeeBeanProcessing.natural:
        return '내추럴';
      case CoffeeBeanProcessing.washed:
        return '워시드';
      case CoffeeBeanProcessing.washedFermented:
        return '워시드 퍼먼티드';
      case CoffeeBeanProcessing.honey:
        return '허니';
      case CoffeeBeanProcessing.sugarCane:
        return '슈가케인';
      case CoffeeBeanProcessing.anaerobicFermentation:
        return '무산소 발효';
      case CoffeeBeanProcessing.mountainWater:
        return '마운틴 워터';
      case CoffeeBeanProcessing.writtenByUser:
        return '직적 입력';
    }
  }
}
