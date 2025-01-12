enum ExtractionType {
  handDrip,
  espressoMachine,
  coffeeMaker,
  mokaPot,
  frenchPress,
  aeroPress,
  coldBrew;


  @override
  String toString() => switch (this) {
    ExtractionType.handDrip => '핸드 드립',
    ExtractionType.espressoMachine => '에스프레소 머신',
    ExtractionType.coffeeMaker => '커피메이커',
    ExtractionType.mokaPot => '모카포트',
    ExtractionType.frenchPress => '프렌치프레스',
    ExtractionType.aeroPress => '에어로프레스',
    ExtractionType.coldBrew => '콜드브루',
  };
}
