import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/data/repository/tasted_record_repository.dart';
import 'package:brew_buds/model/tasted_record/tasted_record_in_profile.dart';

typedef GridViewState = ({
  List<TastedRecordInProfile> tastedRecords,
  List<TastedRecordInProfile> selectedTastedRecords,
});

final class TastedRecordGridPresenter extends Presenter {
  final TastedRecordRepository _tastedRecordRepository = TastedRecordRepository.instance;
  final List<TastedRecordInProfile> _tastedRecords = List.empty(growable: true);
  final List<TastedRecordInProfile> _selectedTastedRecords;
  int _currentPage = 1;
  bool _hasNext = true;
  bool _isLoading = false;

  bool get hasSelectedItem => _selectedTastedRecords.isNotEmpty;

  List<TastedRecordInProfile> get selectedTastedRecords => List.unmodifiable(_selectedTastedRecords);

  GridViewState get gridViewState => (
        tastedRecords: List.unmodifiable(_tastedRecords),
        selectedTastedRecords: List.unmodifiable(_selectedTastedRecords),
      );

  bool get hasNext => _hasNext;

  bool get isLoading => _isLoading;

  refresh() {
    _tastedRecords.clear();
    _currentPage = 1;
    fetchMoreData();
  }

  fetchMoreData() async {
    final id = AccountRepository.instance.id;
    if (id != null && _hasNext) {
      _isLoading = true;
      notifyListeners();

      final newPage = await _tastedRecordRepository.fetchTastedRecordPage(userId: id, pageNo: _currentPage);
      _tastedRecords.addAll(newPage.results);
      _hasNext = newPage.hasNext;
      _currentPage++;
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> onSelected(TastedRecordInProfile tastedRecord) async {
    if (_selectedTastedRecords.contains(tastedRecord)) {
      _selectedTastedRecords.remove(tastedRecord);
    } else {
      if (_selectedTastedRecords.length < 10) {
        _selectedTastedRecords.add(tastedRecord);
      } else {
        throw Exception();
      }
    }
    notifyListeners();
  }

  onDeletedAt(int index) {
    _selectedTastedRecords.removeAt(index);
    notifyListeners();
  }

  TastedRecordGridPresenter({
    required List<TastedRecordInProfile> selectedTastedRecords,
  }) : _selectedTastedRecords = selectedTastedRecords {
    fetchMoreData();
  }
}
