import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/profile/model/follow_user.dart';
import 'package:flutter/foundation.dart';

final class FollowerListPresenter extends ChangeNotifier {
  final int id;
  final String nickName;
  final FollowApi _api = FollowApi();

  int _currentTab = 0;
  int _pageNo = 1;
  bool _hasNext = true;

  final List<FollowUser> _followings = [];
  final List<FollowUser> _followers = [];

  List<FollowUser> get users => _currentTab == 0 ? _followers : _followings;

  FollowerListPresenter({
    required this.id,
    required this.nickName,
  });

  init(int index) {
    _currentTab = index;
    moreData();
  }

  moreData({bool changedTab = false}) {
    if (changedTab) {
      _pageNo = 1;
      _hasNext = true;
      _followings.clear();
      _followers.clear();
    }

    if (_currentTab == 0) {
      _fetchFollowers();
    } else {
      _fetchFollowings();
    }
  }

  onChangeTab(int index) {
    _currentTab = index;
    moreData(changedTab: true);
  }

  _fetchFollowings() {
    if (!_hasNext) return;
    _api.fetchMyFollowList(pageNo: _pageNo, type: 'following').then(
          (jsonString) {
        final jsonData = jsonDecode(jsonString);
        final page = DefaultPage<FollowUser>.fromJson(
          jsonData,
              (json) => FollowUser.fromJson(json as Map<String, dynamic>),
        );
        _hasNext = page.hasNext;
        _pageNo += 1;
        _followings.addAll(page.result);
      },
    ).whenComplete(() => notifyListeners());
  }

  _fetchFollowers() {
    if (!_hasNext) return;
    _api.fetchMyFollowList(pageNo: _pageNo, type: 'follower').then(
          (jsonString) {
        final jsonData = jsonDecode(jsonString);
        final page = DefaultPage<FollowUser>.fromJson(
          jsonData,
              (json) => FollowUser.fromJson(json as Map<String, dynamic>),
        );
        _hasNext = page.hasNext;
        _pageNo += 1;
        _followers.addAll(page.result);
      },
    ).whenComplete(() => notifyListeners());
  }

  onTappedFollowButton(FollowUser user, int index) {
    if (user.isFollowing) {
      _api.unFollow(id: user.user.id).then((_) {
        if (_currentTab == 0) {
          _followings[index] = user.copyWith(isFollowing: true);
        } else {
          _followings[index] = user.copyWith(isFollowing: false);
        }
      }).whenComplete(() => notifyListeners());
    } else {
      _api.follow(id: user.user.id).then((_) {
        if (_currentTab == 0) {
          _followings[index] = user.copyWith(isFollowing: false);
        } else {
          _followings[index] = user.copyWith(isFollowing: true);
        }
      }).whenComplete(() => notifyListeners());
    }
  }
}
