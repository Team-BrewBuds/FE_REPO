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
        return '직접 입력';
    }
  }

  static CoffeeBeanProcessing? fromString(String string) {
    if (string == '내추럴') {
      return CoffeeBeanProcessing.natural;
    } else if (string == '워시드') {
      return CoffeeBeanProcessing.washed;
    } else if (string == '워시드 퍼먼티드') {
      return CoffeeBeanProcessing.washedFermented;
    } else if (string == '허니') {
      return CoffeeBeanProcessing.honey;
    } else if (string == '슈가케인') {
      return CoffeeBeanProcessing.sugarCane;
    } else if (string == '무산소 발효') {
      return CoffeeBeanProcessing.anaerobicFermentation;
    } else if (string == '마운틴 워터') {
      return CoffeeBeanProcessing.mountainWater;
    } else {
      return null;
    }
  }
}
