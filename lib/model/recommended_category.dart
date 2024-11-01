import 'package:freezed_annotation/freezed_annotation.dart';

enum RecommendedCategory {
  @JsonKey(name: "cafe_tour")
  cafeTour,
  @JsonKey(name: "coffee_extraction")
  coffeeExtraction,
  @JsonKey(name: "coffee_study")
  coffeeStudy,
  @JsonKey(name: "cafe_alba")
  cafeAlba,
  @JsonKey(name: "cafe_work")
  cafeWork,
  @JsonKey(name: "cafe_operation")
  cafeOperation;

  String title() => switch (this) {
    RecommendedCategory.cafeTour => '카페 투어를 즐기는 버디',
    RecommendedCategory.coffeeExtraction => '커피 추출을 즐기는 버디',
    RecommendedCategory.coffeeStudy => '커피 공부를 즐기는 버디',
    RecommendedCategory.cafeAlba => '카페 알바하는 버디',
    RecommendedCategory.cafeWork => '카페 근무하는 버디',
    RecommendedCategory.cafeOperation => '카페 운영하는 버디',
  };

  String contents() => switch (this) {
    RecommendedCategory.cafeTour => '오늘은 새로운 버디와 카페 투어 어때요?',
    RecommendedCategory.coffeeExtraction => '오늘은 새로운 버디와 커피 추출 어때요?',
    RecommendedCategory.coffeeStudy => '오늘은 새로운 버디와 커피 공부 어때요?',
    RecommendedCategory.cafeAlba => '오늘은 새로운 버디와 카페 알바에 관한 대화 어때요?',
    RecommendedCategory.cafeWork => '오늘은 새로운 버디와 바리스타 일에 관한 대화 어때요?',
    RecommendedCategory.cafeOperation => '오늘은 새로운 버디와 카페 운영에 관한 대화 어때요?',
  };
}