import 'package:brew_buds/domain/search/core/search_presenter.dart';

typedef RecommendedBeanState = ({String imageUrl, String title, double rating, int commentsCount});

final class SearchHomePresenter extends SearchPresenter {
  List<String> _recentSearchWords = [];
  List<RecommendedBeanState> _recommendedBeanList = [];
  List<String> _beanRankingList = [];

  SearchHomePresenter({
    required super.currentTabIndex,
    required super.searchWord,
  });

  List<String> get recentSearchWords => _recentSearchWords;

  List<RecommendedBeanState> get recommendedBeanList => _recommendedBeanList;

  List<String> get beanRankingList => _beanRankingList;

  @override
  fetchData() {
    _fetchRecentSearchWords();
    _fetchRecommendedBeanList();
    _fetchBeanRankingList();
  }

  _fetchRecentSearchWords() async {
    final words = await storage.read(key: 'RecentSearchWords');
    if (words != null) {
      _recentSearchWords = List.from(words.split(','));
      notifyListeners();
    }
  }

  _fetchRecommendedBeanList() {
    _recommendedBeanList = List.from(_coffeeBeanDummy);
    notifyListeners();
  }

  _fetchBeanRankingList() {
    _beanRankingList = List.from(_coffeeBeansRankingDummy);
    notifyListeners();
  }

  removeAtSearchRecord(int index) {
    _recentSearchWords = List.from(_recentSearchWords..removeAt(index));
    if (_recentSearchWords.isEmpty) {
      storage.delete(key: 'RecentSearchWords');
    } else {
      storage.write(key: 'RecentSearchWords', value: _recentSearchWords.join(','));
    }
    notifyListeners();
  }

  removeAllSearchRecord() {
    _recentSearchWords = List.from([]);
    storage.delete(key: 'RecentSearchWords');
    notifyListeners();
  }

  @override
  onComplete() {}
}

final List<RecommendedBeanState> _coffeeBeanDummy = [
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 시다모 G2 워시드', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 구지 시다모 G1', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 예가체프 G4', rating: 4.8, commentsCount: 220),
  (imageUrl: 'https://loremflickr.com/600/400', title: '에티오피아 아리차 예가체프 G1 내추럴', rating: 4.8, commentsCount: 220),
];

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
