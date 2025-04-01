import 'package:brew_buds/domain/search/core/search_presenter.dart';
import 'package:brew_buds/model/recommended/recommended_coffee_bean.dart';

final class SearchHomePresenter extends SearchPresenter {
  bool _isLoadingRecommendedBeanList = false;
  List<RecommendedCoffeeBean> _recommendedBeanList = [];
  List<String> _beanRankingList = [];

  SearchHomePresenter({
    required super.currentTabIndex,
    required super.searchWord,
  });

  List<RecommendedCoffeeBean> get recommendedBeanList => _recommendedBeanList;

  bool get isLoadingRecommendedBeanList => _isLoadingRecommendedBeanList;

  List<String> get beanRankingList => _beanRankingList;

  @override
  initState() {
    super.initState();
    _fetchRecommendedBeanList();
    _fetchBeanRankingList();
  }

  @override
  onRefresh() async {
    fetchRecentSearchWords();
    _fetchBeanRankingList();
    await _fetchRecommendedBeanList();
  }

  Future<void> _fetchRecommendedBeanList() async {
    _isLoadingRecommendedBeanList = true;
    notifyListeners();

    _recommendedBeanList = List.from(await searchRepository.fetchRecommendedCoffeeBean());
    _isLoadingRecommendedBeanList = false;
    notifyListeners();
  }

  _fetchBeanRankingList() {
    _beanRankingList = List.from(_coffeeBeansRankingDummy);
    notifyListeners();
  }

  @override
  fetchData() {}
}

final List<String> _coffeeBeansRankingDummy = [
  '과테말라 안티구아',
  '콜롬비아 후일라 수프리모',
  '에티오피아 예가체프 G4',
  '싱글 케냐 AA Plus 아이히더 워시드',
  '에티오피아 아리차 예가체프 G1 내추럴',
  '에티오피아 구지 시다모 G1',
  '브라질 세하도 FC NY2 내추럴',
  '코스타리카 따라주 SHB 워시드',
  '에티오피아 사다모 G2 워시드',
  '에티오피아 사다모 G2 워시드',
];
