enum Country {
  guatemala,
  nicaragua,
  mexico,
  bolivia,
  brazil,
  ecuador,
  elSalvador,
  honduras,
  jamaica,
  costaRica,
  colombia,
  panama,
  peru,
  rwanda,
  ethiopia,
  kenya,
  sumatra,
  yemen,
  india,
  indonesia,
  papuaNewGuinea,
  hawaii;

  @override
  String toString() => switch (this) {
        Country.guatemala => '과테말라',
        Country.nicaragua => '니카라과',
        Country.mexico => '멕시코',
        Country.bolivia => '볼리비아',
        Country.brazil => '브라질',
        Country.ecuador => '에콰도르',
        Country.elSalvador => '엘살바도르',
        Country.honduras => '온두라스',
        Country.jamaica => '자메이카',
        Country.costaRica => '코스타리카',
        Country.colombia => '콜롬비아',
        Country.panama => '파나마',
        Country.peru => '페루',
        Country.rwanda => '르완다',
        Country.ethiopia => '에티오피아',
        Country.kenya => '케냐',
        Country.sumatra => '수마트라',
        Country.yemen => '예멘',
        Country.india => '인도',
        Country.indonesia => '인도네시아',
        Country.papuaNewGuinea => '파푸아뉴기니',
        Country.hawaii => '하와이',
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
            Country.ecuador,
            Country.elSalvador,
            Country.honduras,
            Country.jamaica,
            Country.costaRica,
            Country.colombia,
            Country.panama,
            Country.peru,
          ],
        Continent.africa => [
            Country.rwanda,
            Country.ethiopia,
            Country.kenya,
          ],
        Continent.etc => [
            Country.sumatra,
            Country.yemen,
            Country.india,
            Country.indonesia,
            Country.papuaNewGuinea,
            Country.hawaii,
          ],
      };

  @override
  String toString() => switch (this) {
        Continent.latinAmerica => '중남미',
        Continent.africa => '아프리카',
        Continent.etc => '기타',
      };
}


