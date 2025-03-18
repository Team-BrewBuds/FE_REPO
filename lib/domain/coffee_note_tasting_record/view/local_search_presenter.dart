import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/local.dart';
import 'package:flutter/foundation.dart';

final class LocalSearchPresenter extends ChangeNotifier {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  String _searchWord = '';
  DefaultPage<Local> _page = DefaultPage.initState();
  int _pageNo = 1;

  DefaultPage<Local> get page => _page;

  initState() {}

  fetchMoreData() async {
    if (_page.hasNext) {
      final newPage = await _tastedRecordRepository.fetchLocal(word: _searchWord, pageNo: _pageNo);
      _page = newPage.copyWith(results: _page.results + newPage.results);
      _pageNo++;
      notifyListeners();
    }
  }

  search(String word) {
    _page = DefaultPage.initState();
    _pageNo = 1;
    _searchWord = word;
    fetchMoreData();
  }
}
