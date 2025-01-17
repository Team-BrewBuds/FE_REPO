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

enum ProcessType {
  Natural,
  Washed,
  PulpedNatural,
  Honey,
  AnaerobicFermentation,
  etc; // 직접입력

  @override
  String toString() => switch (this) {
        ProcessType.Natural => '내추럴',
        ProcessType.Washed => '위시드',
        ProcessType.PulpedNatural => '펄프드 내추럴',
        ProcessType.Honey => '허니',
        ProcessType.AnaerobicFermentation => '무산소 발표',
        ProcessType.etc => '직접입력',
      };
}

enum Flavor {
  rich,
  creamy,
  smooth,
  clean,
  longFinish,
  bright,
  balance,
  light,
  heavy,
  acidity,
  refreshing,
  citrus,
  tropical,
  berry,
  floral,
  herbal,
  spicy,
  juicy,
  tea,
  nutty,
  toasty,
  bitter,
  cinnamon,
  smoky,
  grain,
  sweet,
  vanilla,
  chocolate,
  caramel;

  @override
  String toString() => switch (this) {
        Flavor.rich => '풍부한',
        Flavor.creamy => '크리미한',
        Flavor.smooth => '부드러움',
        Flavor.clean => '깔끔',
        Flavor.longFinish => '긴 여운',
        Flavor.bright => '화사한',
        Flavor.balance => '밸런스',
        Flavor.light => '가벼운',
        Flavor.heavy => '묵직',
        Flavor.acidity => '산미',
        Flavor.refreshing => '상큼',
        Flavor.citrus => '시트러스',
        Flavor.tropical => '트로피칼',
        Flavor.berry => '베리',
        Flavor.floral => '꽃',
        Flavor.herbal => '허브',
        Flavor.spicy => '향신료',
        Flavor.juicy => '주스 같은',
        Flavor.tea => '차 같은',
        Flavor.nutty => '견과류',
        Flavor.toasty => '고소',
        Flavor.bitter => '쌉쌀',
        Flavor.cinnamon => '시나몬',
        Flavor.smoky => '스모키',
        Flavor.grain => '곡물',
        Flavor.sweet => '달콤',
        Flavor.vanilla => '바닐라',
        Flavor.chocolate => '초콜릿',
        Flavor.caramel => '카라멜'
      };
}

enum BeanFlavor {
  impression,
  body,
  acidity,
  bitterness,
  sweetness;

  List<Flavor> beanFlavor() => switch (this) {
        BeanFlavor.impression => [
            Flavor.rich,
            Flavor.creamy,
            Flavor.smooth,
            Flavor.clean,
            Flavor.longFinish,
            Flavor.bright,
          ],
        BeanFlavor.body => [Flavor.balance, Flavor.light, Flavor.heavy],
        BeanFlavor.acidity => [
            Flavor.acidity,
            Flavor.refreshing,
            Flavor.citrus,
            Flavor.tropical,
            Flavor.berry,
            Flavor.floral,
            Flavor.herbal,
            Flavor.spicy,
            Flavor.juicy,
            Flavor.tea
          ],
        BeanFlavor.bitterness => [
          Flavor.nutty,
          Flavor.toasty,
          Flavor.bitter,
          Flavor.cinnamon,
          Flavor.smoky,
          Flavor.grain
        ],
        BeanFlavor.sweetness => [
          Flavor.sweet,
          Flavor.vanilla,
          Flavor.chocolate,
          Flavor.caramel
        ],
      };

  @override
  String toString() => switch (this) {
        BeanFlavor.impression => '맛의 인상',
        BeanFlavor.body => '바디감',
        BeanFlavor.acidity => '산미',
        BeanFlavor.bitterness => '쓴맛',
        BeanFlavor.sweetness => '단맛'
      };
}
