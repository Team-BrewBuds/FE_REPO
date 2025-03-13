import 'dart:convert';

import 'package:brew_buds/data/api/block_api.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/domain/setting/model/blocked_user.dart';
import 'package:flutter/foundation.dart';

final class BlockingUserManagementPresenter extends ChangeNotifier {
  final BlockApi _blockApi = BlockApi();

  DefaultPage<BlockedUser> _page = DefaultPage.initState();

  DefaultPage<BlockedUser> get page => _page;

  initState() async {
    fetchMoreData();
  }

  refresh() {
    _page = DefaultPage.initState();
    fetchMoreData();
  }

  fetchMoreData() async {
    if (!_page.hasNext) return;

    final jsonString = await _blockApi.fetchBlockList();
    final decodedJson = jsonDecode(jsonString);
    final newPage = DefaultPage<BlockedUser>.fromJson(
      decodedJson,
      (jsonT) => BlockedUser.fromJson(jsonT as Map<String, dynamic>),
    );

    _page = _page.copyWith(results: _page.results + newPage.results, hasNext: newPage.hasNext);
    notifyListeners();
  }

  Future<bool> unBlock({required int id}) {
    return _blockApi.unBlock(id: id).then(
      (_) {
        refresh();
        return true;
      },
      onError: (_, __) => false,
    );
  }
}
