import 'package:brew_buds/core/presenter.dart';

enum ProfileImageFlow { album, camera }

final class ProfileImageNavigatorPresenter extends Presenter {
  List<ProfileImageFlow> _steps = [ProfileImageFlow.album]; // 초기 상태

  List<ProfileImageFlow> get steps => List.unmodifiable(_steps);

  void goTo(ProfileImageFlow step) {
    _steps.add(step);
    notifyListeners();
  }

  void replace(ProfileImageFlow step) {
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