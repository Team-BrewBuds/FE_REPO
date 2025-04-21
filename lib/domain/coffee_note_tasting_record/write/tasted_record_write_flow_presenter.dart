import 'package:brew_buds/core/presenter.dart';
import 'package:brew_buds/domain/coffee_note_tasting_record/write/tasted_record_write_flow.dart';

final class TastedRecordWriteFlowPresenter extends Presenter {
  List<TastedRecordWriteFlow> _steps = [AlbumSelectStep()]; // 초기 상태

  List<TastedRecordWriteFlow> get steps => List.unmodifiable(_steps);

  void goTo(TastedRecordWriteFlow step) {
    _steps.add(step);
    notifyListeners();
  }

  void replace(TastedRecordWriteFlow step) {
    if (_steps.isNotEmpty) {
      _steps.removeLast();
    }
    _steps.add(step);
    notifyListeners();
  }

  void back() {
    if (_steps.length > 1) {
      _steps.removeLast();
      notifyListeners();
    }
  }

  void closeFlow() {
    _steps = [];
    notifyListeners();
  }
}
