import 'dart:convert';

import 'package:brew_buds/data/api/tasted_record_api.dart';
import 'package:brew_buds/data/repository/account_repository.dart';
import 'package:brew_buds/model/default_page.dart';
import 'package:brew_buds/profile/model/in_profile/tasting_record_in_profile.dart';
import 'package:flutter/foundation.dart';

typedef GridViewState = ({
  List<TastingRecordInProfile> tastingRecords,
  List<TastingRecordInProfile> selectedTastingRecords,
});

final class TastingRecordGridPresenter extends ChangeNotifier {
  final TastedRecordApi _api = TastedRecordApi();
  List<TastingRecordInProfile> _selectedTastingRecords;
  DefaultPage<TastingRecordInProfile> _tastingRecordsPage = DefaultPage.empty();
  int _currentPage = 1;

  bool get hasSelectedItem => _selectedTastingRecords.isNotEmpty;

  List<TastingRecordInProfile> get selectedTastingRecords => _selectedTastingRecords;

  GridViewState get gridViewState => (
        tastingRecords: _tastingRecordsPage.result,
        selectedTastingRecords: _selectedTastingRecords,
      );

  initState() {
    fetchMoreData();
  }

  refresh() {
    _tastingRecordsPage = DefaultPage.empty();
    _currentPage = 1;
    fetchMoreData();
  }

  fetchMoreData() {
    final id = AccountRepository.instance.id;
    if (id != null) {
      _api.fetchTastedRecordPage(userId: id, pageNo: _currentPage).then(
        (jsonString) {
          final json = jsonDecode(jsonString);
          final nextPage = DefaultPage.fromJson(
            json,
            (jsonT) => TastingRecordInProfile.fromJson(jsonT as Map<String, dynamic>),
          );
          _tastingRecordsPage = _tastingRecordsPage.copyWith(
            result: _tastingRecordsPage.result + nextPage.result,
            hasNext: nextPage.hasNext,
          );
          _currentPage += 1;
        },
      ).whenComplete(() => notifyListeners());
    }
  }

  bool onSelected(TastingRecordInProfile tastingRecord) {
    if (_selectedTastingRecords.contains(tastingRecord)) {
      _selectedTastingRecords = List.from(_selectedTastingRecords)..remove(tastingRecord);
    } else {
      if (_selectedTastingRecords.length < 10) {
        _selectedTastingRecords = List.from(_selectedTastingRecords)..add(tastingRecord);
      } else {
        return false;
      }
    }
    notifyListeners();
    return true;
  }

  onDeletedAt(int index) {
    _selectedTastingRecords = List.from(_selectedTastingRecords)..removeAt(index);
    notifyListeners();
  }

  TastingRecordGridPresenter({
    required List<TastingRecordInProfile> selectedTastingRecords,
  }) : _selectedTastingRecords = selectedTastingRecords;
}
