import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/common/default_page.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';

typedef GridViewState = ({
  List<TastedRecordInProfile> tastedRecords,
  List<TastedRecordInProfile> selectedTastedRecords,
});

final class TastedRecordGridPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  List<TastedRecordInProfile> _selectedTastedRecords;
  DefaultPage<TastedRecordInProfile> _tastedRecordsPage = DefaultPage.initState();
  int _currentPage = 1;

  bool get hasSelectedItem => _selectedTastedRecords.isNotEmpty;

  List<TastedRecordInProfile> get selectedTastedRecords => _selectedTastedRecords;

  GridViewState get gridViewState => (
        tastedRecords: _tastedRecordsPage.results,
        selectedTastedRecords: _selectedTastedRecords,
      );

  initState() {
    fetchMoreData();
  }

  refresh() {
    _tastedRecordsPage = DefaultPage.initState();
    _currentPage = 1;
    fetchMoreData();
  }

  fetchMoreData() async {
    final id = AccountRepository.instance.id;
    if (id != null) {
      final newPage = await _tastedRecordRepository.fetchTastedRecordPage(userId: id, pageNo: _currentPage);
      _tastedRecordsPage = newPage.copyWith(results: _tastedRecordsPage.results + newPage.results);
      notifyListeners();
    }
  }

  bool onSelected(TastedRecordInProfile tastedRecord) {
    if (_selectedTastedRecords.contains(tastedRecord)) {
      _selectedTastedRecords = List.from(_selectedTastedRecords)..remove(tastedRecord);
    } else {
      if (_selectedTastedRecords.length < 10) {
        _selectedTastedRecords = List.from(_selectedTastedRecords)..add(tastedRecord);
      } else {
        return false;
      }
    }
    notifyListeners();
    return true;
  }

  onDeletedAt(int index) {
    _selectedTastedRecords = List.from(_selectedTastedRecords)..removeAt(index);
    notifyListeners();
  }

  TastedRecordGridPresenter({
    required List<TastedRecordInProfile> selectedTastedRecords,
  }) : _selectedTastedRecords = selectedTastedRecords;
}
