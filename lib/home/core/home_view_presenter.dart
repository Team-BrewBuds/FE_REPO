import 'package:brew_buds/model/recommended_user.dart';
import 'package:brew_buds/model/user.dart';
import 'package:flutter/foundation.dart';

abstract class HomeViewPresenter<T> extends ChangeNotifier {
  List<T> get feeds;

  bool get hasNext;

  Future<void> initState();

  Future<void> onRefresh();

  Future<void> fetchMoreData();

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

  List<RecommendedUser> fetchRecommendedUsers() => _dummyRecommendedUsers;
}

final List<RecommendedUser> _dummyRecommendedUsers = [
  RecommendedUser(user: User(id: 0, nickname: '김씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 1985789),
  RecommendedUser(user: User(id: 1, nickname: '이씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 3452),
  RecommendedUser(user: User(id: 2, nickname: '박씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 1985456789),
  RecommendedUser(user: User(id: 3, nickname: '홍씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 33425),
  RecommendedUser(user: User(id: 4, nickname: '임씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 234672),
  RecommendedUser(user: User(id: 5, nickname: '윤씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 62456),
  RecommendedUser(user: User(id: 6, nickname: '왕씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 234),
  RecommendedUser(user: User(id: 7, nickname: '송씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 6435735),
  RecommendedUser(user: User(id: 8, nickname: '류씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 563),
  RecommendedUser(user: User(id: 9, nickname: '강씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 2346),
  RecommendedUser(user: User(id: 10, nickname: '심씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 9456),
  RecommendedUser(user: User(id: 11, nickname: '오씨', profileImageUri: 'https://picsum.photos/600/400', isFollowed: false), followerCount: 23457),
];