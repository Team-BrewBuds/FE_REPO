import 'dart:convert';

import 'package:brew_buds/data/api/follow_api.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/follow_list/follow_user.dart';
import 'package:flutter/foundation.dart';

final class FollowerListPresenter extends ChangeNotifier {
  final int id;
  final String nickName;
  final FollowApi _api = FollowApi();

  DefaultPage<FollowUser>? _page;
  int _currentTab = 0;
  int _pageNo = 1;

  bool get hasNext => _page?.hasNext ?? true;

  DefaultPage<FollowUser>? get page => _page;

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
      _page = DefaultPage.empty();
      notifyListeners();
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
    if (!hasNext) return;
    _api.fetchMyFollowList(pageNo: _pageNo, type: 'following').then(
      (jsonString) {
        final jsonData = jsonDecode(jsonString);
        final page = DefaultPage<FollowUser>.fromJson(
          jsonData,
          (json) => FollowUser.fromJson(json as Map<String, dynamic>),
        );
        _page = page.copyWith(result: (_page?.result ?? []) + page.result);
        _pageNo += 1;
      },
    ).whenComplete(() => notifyListeners());
  }

  _fetchFollowers() {
    if (!hasNext) return;
    _api.fetchMyFollowList(pageNo: _pageNo, type: 'follower').then(
      (jsonString) {
        final jsonData = jsonDecode(jsonString);
        final page = DefaultPage<FollowUser>.fromJson(
          jsonData,
          (json) => FollowUser.fromJson(json as Map<String, dynamic>),
        );
        _page = page.copyWith(result: (_page?.result ?? []) + page.result);
        _pageNo += 1;
      },
    ).whenComplete(() => notifyListeners());
  }

  onTappedFollowButton(FollowUser user, int index) {
    final currentPage = _page;
    if (currentPage != null) {
      if (user.isFollowing) {
        _api.unFollow(id: user.user.id).then((_) {
          _page = currentPage.copyWith(
              result: currentPage.result.map(
                    (e) {
                  if (e.user.id == user.user.id) {
                    return user.copyWith(isFollowing: false);
                  } else {
                    return e;
                  }
                },
              ).toList());
        }).whenComplete(() => notifyListeners());
      } else {
        _api.follow(id: user.user.id).then((_) {
          _page = currentPage.copyWith(
              result: currentPage.result.map(
                    (e) {
                  if (e.user.id == user.user.id) {
                    return user.copyWith(isFollowing: true);
                  } else {
                    return e;
                  }
                },
              ).toList());
        }).whenComplete(() => notifyListeners());
      }
    }
  }
}
