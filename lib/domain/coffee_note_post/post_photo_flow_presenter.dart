import 'package:brew_buds/core/presenter.dart';

enum PostPhotoFlow { album, camera }

final class PostPhotoFlowPresenter extends Presenter {
  List<PostPhotoFlow> _steps = [PostPhotoFlow.album]; // 초기 상태

  List<PostPhotoFlow> get steps => List.unmodifiable(_steps);

  void goTo(PostPhotoFlow step) {
    _steps.add(step);
    notifyListeners();
  }

  void replace(PostPhotoFlow step) {
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
