enum CoffeeLife {
  cafeTour,
  coffeeExtraction,
  coffeeStudy,
  cafeAlba,
  cafeWork,
  cafeOperation;

  String get title => switch (this) {
        CoffeeLife.cafeTour => '커피 투어',
        CoffeeLife.coffeeExtraction => '커피 추출',
        CoffeeLife.coffeeStudy => '커피 공부',
        CoffeeLife.cafeAlba => '커피 알바',
        CoffeeLife.cafeWork => '커피 근무',
        CoffeeLife.cafeOperation => '커피 운영',
      };

  String get description => switch (this) {
        CoffeeLife.cafeTour => '내 취향의 원두를 찾기 위해서 커피 투어를 해요',
        CoffeeLife.coffeeExtraction => '집이나 회사에서 직접 추출한 커피를 마셔요',
        CoffeeLife.coffeeStudy => '커피 관련 지식을 쌓고 자격증 취득을 위해 공부해요',
        CoffeeLife.cafeAlba => '본업은 있지만 커피를 좋아해서 커피 알바를 해요',
        CoffeeLife.cafeWork => '커피 전문가가 되기 위해서 바리스타로 근무해요',
        CoffeeLife.cafeOperation => '커피 문화를 전달하기 위해서 카페를 직접 운영해요',
      };

  String get imagePath => switch (this) {
        CoffeeLife.cafeTour => 'assets/images/coffee_life/cafe_tour.png',
        CoffeeLife.coffeeExtraction => 'assets/images/coffee_life/coffee_extraction.png',
        CoffeeLife.coffeeStudy => 'assets/images/coffee_life/coffee_study.png',
        CoffeeLife.cafeAlba => 'assets/images/coffee_life/cafe_part_time.png',
        CoffeeLife.cafeWork => 'assets/images/coffee_life/cafe_work.png',
        CoffeeLife.cafeOperation => 'assets/images/coffee_life/cafe_operation.png',
      };
}
