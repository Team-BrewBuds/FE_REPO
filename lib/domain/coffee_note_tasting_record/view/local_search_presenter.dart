import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/common/local.dart';

final class LocalSearchPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  String _searchWord = '';
  DefaultPage<Local> _page = DefaultPage.initState();
  String _x = '';
  String _y = '';
  int _pageNo = 1;

  DefaultPage<Local> get page => _page;

  initState() {
    _page = DefaultPage.initState();
    _pageNo = 1;
  }

  fetchMoreData() async {
    if (_page.hasNext) {
      final newPage = await _tastedRecordRepository.fetchLocal(
        word: _searchWord,
        pageNo: _pageNo,
        x: _x.isEmpty ? null : _x,
        y: _y.isEmpty ? null : _y,
      );
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

  setMyLocation({required String x, required String y}) {
    _x = x;
    _y = y;
    if (_x.isNotEmpty && _y.isNotEmpty) {
      search(_searchWord);
    }
  }
}
