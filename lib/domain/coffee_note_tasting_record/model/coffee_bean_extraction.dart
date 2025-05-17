enum CoffeeBeanExtraction {
  handDrip,
  espressoMachine,
  coffeeMaker,
  mokaPot,
  frenchPress,
  aeropress,
  coldBrew,
  writtenByUser;

  @override
  String toString() {
    switch (this) {
      case CoffeeBeanExtraction.handDrip:
        return '핸드 드립';
      case CoffeeBeanExtraction.espressoMachine:
        return '에스프레소 머신';
      case CoffeeBeanExtraction.coffeeMaker:
        return '커피 메이커';
      case CoffeeBeanExtraction.mokaPot:
        return '모카 포트';
      case CoffeeBeanExtraction.frenchPress:
        return '프랜치 프레스';
      case CoffeeBeanExtraction.aeropress:
        return '에어로 프레스';
      case CoffeeBeanExtraction.coldBrew:
        return '콜드 브루';
      case CoffeeBeanExtraction.writtenByUser:
        return '직접 입력';
    }
  }
}
