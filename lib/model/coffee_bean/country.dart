enum Country {
  guatemala,
  nicaragua,
  mexico,
  bolivia,
  brazil,
  elSalvador,
  honduras,
  costaRica,
  colombia,
  panama,
  peru,
  rwanda,
  ethiopia,
  cameroon,
  kenya,
  korea,
  vietnam,
  india,
  indonesia;

  @override
  String toString() => switch (this) {
        Country.guatemala => '과테말라',
        Country.nicaragua => '니카라과',
        Country.mexico => '멕시코',
        Country.bolivia => '볼리비아',
        Country.brazil => '브라질',
        Country.elSalvador => '엘살바도르',
        Country.honduras => '온두라스',
        Country.costaRica => '코스타리카',
        Country.colombia => '콜롬비아',
        Country.panama => '파나마',
        Country.peru => '페루',
        Country.rwanda => '르완다',
        Country.ethiopia => '에티오피아',
        Country.kenya => '케냐',
        Country.india => '인도',
        Country.indonesia => '인도네시아',
        Country.cameroon => '카메룬',
        Country.korea => '대한민국',
        Country.vietnam => '베트남',
      };
}

enum Continent {
  latinAmerica,
  africa,
  etc;

  List<Country> countries() => switch (this) {
        Continent.latinAmerica => [
            Country.guatemala,
            Country.nicaragua,
            Country.mexico,
            Country.bolivia,
            Country.brazil,
            Country.elSalvador,
            Country.honduras,
            Country.costaRica,
            Country.colombia,
            Country.panama,
            Country.peru,
          ],
        Continent.africa => [
            Country.rwanda,
            Country.ethiopia,
            Country.cameroon,
            Country.kenya,
          ],
        Continent.etc => [
            Country.korea,
            Country.vietnam,
            Country.india,
            Country.indonesia,
          ],
      };

  @override
  String toString() => switch (this) {
        Continent.latinAmerica => '중남미',
        Continent.africa => '아프리카',
        Continent.etc => '기타',
      };
}
