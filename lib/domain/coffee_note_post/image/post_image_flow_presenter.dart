import 'package:brew_buds/core/presenter.dart';

enum PostImageFlow { album, camera }

final class PostImageFlowPresenter extends Presenter {
  List<PostImageFlow> _steps = [PostImageFlow.album]; // 초기 상태

  List<PostImageFlow> get steps => List.unmodifiable(_steps);

  void goTo(PostImageFlow step) {
    _steps.add(step);
    notifyListeners();
  }

  void replace(PostImageFlow step) {
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
