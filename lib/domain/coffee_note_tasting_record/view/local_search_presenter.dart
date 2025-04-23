import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/common/local.dart';

final class LocalSearchPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  final List<Local> _localList = [];
  String _searchWord = '';
  String _x = '';
  String _y = '';
  int _pageNo = 1;
  bool _hasNext = true;

  List<Local> get localList => List.unmodifiable(_localList);

  fetchMoreData() async {
    if (_hasNext) {
      final newPage = await _tastedRecordRepository.fetchLocal(
        word: _searchWord,
        pageNo: _pageNo,
        x: _x.isEmpty ? null : _x,
        y: _y.isEmpty ? null : _y,
      );
      _localList.addAll(newPage.results);
      _hasNext = newPage.hasNext;
      _pageNo++;
      notifyListeners();
    }
  }

  search(String word) {
    _localList.clear();
    _pageNo = 1;
    _hasNext = true;
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
