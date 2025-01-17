import 'package:brew_buds/profile/model/coffee_bean_filter.dart';
import 'package:brew_buds/search/models/search_filter.dart';
import 'package:brew_buds/search/models/search_result_model.dart';
import 'package:brew_buds/search/models/search_sort_criteria.dart';
import 'package:brew_buds/search/models/search_subject.dart';
import 'package:flutter/foundation.dart';

final class SearchPresenter extends ChangeNotifier {
  final List<SearchSubject> _subjects = [
    SearchSubject.coffeeBean,
    SearchSubject.buddy,
    SearchSubject.tastedRecord,
    SearchSubject.post,
  ];
  int _tabIndex = 0;
  String _searchWord = '';
  int _currentSortCriteriaIndex = 0;

  final List<CoffeeBeanFilter> _filter = [];

  bool get hasFilter => _filter.isNotEmpty;

  bool get hasBeanTypeFilter => _filter.whereType<BeanTypeFilter>().isNotEmpty;

  bool get hasCountryFilter => _filter.whereType<CountryFilter>().isNotEmpty;

  bool get hasRatingFilter => _filter.whereType<RatingFilter>().isNotEmpty;

  bool get hasDecafFilter => _filter.whereType<DecafFilter>().isNotEmpty;

  bool get hasRoastingPointFilter => _filter.whereType<RoastingPointFilter>().isNotEmpty;

  String get searchWord => _searchWord;

  int get currentSortCriteriaIndex => _currentSortCriteriaIndex;

  List<SearchSortCriteria> get sortCriteriaList => switch(_tabIndex) {
    0 => SearchSortCriteria.coffeeBean(),
    1 => SearchSortCriteria.buddy(),
    2 => SearchSortCriteria.tastedRecord(),
    3 => SearchSortCriteria.post(),
    int() => throw UnimplementedError(),
  };

  String get currentSortCriteria => sortCriteriaList[_currentSortCriteriaIndex].toString();

  List<SearchSubject> get tabs => _subjects;

  int get currentTabIndex => _tabIndex;

  SearchSubject get currentTab => _subjects[_tabIndex];

  List<String> get recentSearchWords => _recentSearchWordsDummy;

  List<String> get haveSearchedWords => _haveSearchedDummy;

  List<String> get suggestWords => _suggestDummy;

  List<(String, double, int)> get recommendedCoffeeBeans => _recommendedCoffeeBeansDummy;

  List<String> get coffeeBeansRanking => _coffeeBeansRankingDummy;

  String get rankUpdatedAt => '10.27 16:00 업데이트';

  List<SearchResultModel> get searchResult => [coffeeBeanDummy, buddyDummy, tastedRecordDummy, postDummy][_tabIndex];

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  onChangeTab(int index) {
    _tabIndex = index;
    _filter.clear();
    _currentSortCriteriaIndex = 0;
    notifyListeners();
  }

  onChangeSearchWord(String newText) {
    _searchWord = newText;
    notifyListeners();
  }

  onDeleteRecentSearchWord(int index) {
    _recentSearchWordsDummy.removeAt(index);
    notifyListeners();
  }

  onAllDeleteRecentSearchWord() {
    _recentSearchWordsDummy.clear();
    notifyListeners();
  }

  onChangeCoffeeBeanFilter(List<CoffeeBeanFilter> filter) {
    _filter.clear();
    _filter.addAll(filter);
    notifyListeners();
  }

  onChangeSortCriteriaIndex(int index) {
    _currentSortCriteriaIndex = index;
    notifyListeners();
  }
}

final List<String> _recentSearchWordsDummy = ['게샤 워시드', '에티오피아', 'G1', '예카체프', '원두추천'];

final coffeeBeanDummy = [
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
  ('에티오피아 시다모 G2 워시드', 4.8, 220),
  ('에티오피아 구지 시다모 G1', 4.8, 220),
  ('에티오피아 예가체프 G4', 4.8, 220),
  ('에티오피아 아리차 예가체프 G1 내추럴', 4.8, 220),
].map((e) => SearchResultModel.coffeeBean(id: 0, name: e.$1, rating: e.$2, recordedCount: e.$3)).toList();

final buddyDummy = [
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
  ('', '에티오피아에서커피한잔', 1293, 283),
].map((e) => SearchResultModel.buddy(id: 0, profileImageUri: e.$1, nickname: e.$2, followerCount: e.$3, tastedRecordsCount: e.$4)).toList();

final tastedRecordDummy = [
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
  (
    '',
    '에티오피아 할로 하르투메 G1 워시드',
    4.5,
    '싱글 오리진',
    ['트로피칼', '트로피칼', '트로피칼', '트로피칼'],
    '산미를 좋아하시면 에티오피아 괜찮아요^^',
  ),
].map((e) => SearchResultModel.tastedRecord(id: 0, title: e.$2, rating: e.$3, beanType: e.$4, taste: e.$5, contents: e.$6, imageUri: e.$1)).toList();

final postDummy = [
  (
    '에티오피아 원두 어때요?',
    '가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하에티오피아 원두 추천드립니다.가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하',
    923,
    30,
    '정보',
    '3시간 전',
    5,
    '커피의 신',
  ),
  (
    '에티오피아 케냐 나이지리아 원두 추천',
    '가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하',
    12,
    2,
    '질문',
    '6주 전',
    10457,
    '일어나자마자커피한잔',
  ),
  (
    '나이지리아 원두 추천',
    '가나다라마바사아자차카타파하가나다라마바사아자차카타파하에티오피아가나다라마바사아자차카타파하가나다라마바사아자차카타파하가나다라마바사아자차카타파하',
    12,
    2,
    '질문',
    '6주 전',
    48,
    '일어나자마자커피한잔',
  ),
].map((e) => SearchResultModel.post(id: 0, title: e.$1, contents: e.$2, likeCount: e.$3, commentCount: e.$4, hits: e.$7, createdAt: e.$6, authorNickname: e.$8, subject: e.$5, imageUri: '')).toList();

final _recommendedCoffeeBeansDummy = [
  ('에티오피아 사다모 G2 워시드', 4.9, 74),
  ('에티오피아 예가 체프 G1', 4.8, 220),
  ('케냐 예가체프 G1 워시드', 4.3, 52),
  ('케냐 예가체프 G1 허니', 4.5, 2120),
];

final List<String> _coffeeBeansRankingDummy = [
  '과테말라 안티구아',
  '콜롬비아 후일라 수프리모',
  '에티오피아 예가체프 G4',
  '싱글 케냐 AA Plus 아이히더 워시드',
  '에티오피아 아리차 예가체프 G1 내추럴',
  '에티오피아 구지 시다모 G1',
  // '브라질 세하도 FC NY2 내추럴',
  // '코스타리카 따라주 SHB 워시드',
  // '에티오피아 사다모 G2 워시드',
  // '에티오피아 사다모 G2 워시드',
];

final List<String> _haveSearchedDummy = [
  '에티오피아 예가체프 G1 코케허니 내추럴',
      '에티오피아 예가체프 G1 코케 워시드'
];

final List<String> _suggestDummy = [
  '에티오피아 예가체프 G1 코케허니 내추럴',
  '에티오피아 예가체프 G1 코케 워시드',
  '에티오피아 예가체프 아바야 게이샤',
  '에티오피아 예가체프 구지 겔라냐 게샤 G1 무산소',
  '에티오피아 시다모 물루게타 문타샤 내추럴',
  '에티오피아 할로 하루투메 G1 워시드',
  '에티오피아 리무 게샤 워시드 ',
  '에티오피아 시다모 G2 워시드 ',
];