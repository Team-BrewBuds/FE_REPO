import 'dart:convert';

import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/domain/setting/model/blocked_user.dart';
import 'package:brew_buds/model/common/default_page.dart';

final class BlockingUserManagementPresenter extends Presenter {
  final BlockApi _blockApi = BlockApi();
  final List<BlockedUser> _users = List.empty(growable: true);
  bool _hasNext = true;
  bool _isLoading = false;

  List<BlockedUser> get users => List.unmodifiable(_users);

  bool get isLoading => _isLoading;

  BlockingUserManagementPresenter() {
    fetchMoreData();
  }

  refresh() {
    _users.clear();
    _hasNext = true;

    fetchMoreData();
  }

  fetchMoreData() async {
    if (!_hasNext || _isLoading) return;

    try {
      _isLoading = true;
      notifyListeners();

      final json = jsonDecode(await _blockApi.fetchBlockList()) as Map<String, dynamic>;
      final nextPage = DefaultPage<BlockedUser>.fromJson(
        json,
        (jsonT) => BlockedUser.fromJson(jsonT as Map<String, dynamic>),
      );
      _users.addAll(nextPage.results);
      _hasNext = nextPage.hasNext;
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> unBlockAt(int index) async {
    if (index < 0 || index >= _users.length) return false;

    final BlockedUser user = _users.removeAt(index);
    notifyListeners();

    try {
      await _blockApi.unBlock(id: user.id);
      return true;
    } catch (e) {
      _users.insert(index, user);
      notifyListeners();
      return false;
    }
  }
}
