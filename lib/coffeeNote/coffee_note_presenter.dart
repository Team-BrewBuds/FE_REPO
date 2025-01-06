import 'package:brew_buds/coffeeNote/controller/custom_controller.dart';
import 'package:flutter/cupertino.dart';

final class CoffeeNotePresenter extends ChangeNotifier {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  late CustomTagController customTagController = CustomTagController();

  String _title = '게시글 주제를 선택해주세요';
  String get title => _title;

  List<String> _tag = [];
  List<String> get tag => _tag;

  // 제목 설정
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  // 태그 추가
  void addTag(String tag) {
    if (!_tag.contains(tag)) {
      _tag.add(tag);
      notifyListeners(); // 태그 리스트 업데이트 후 UI 갱신
    }
  }

  // 태그 제거
  void removeTag(String tag) {
    _tag.remove(tag);
    notifyListeners(); // 태그 리스트 업데이트 후 UI 갱신
  }

  // 태그 수를 체크하고, 제한을 넘지 않도록 하기 위한 메서드
  void setTagCount(int tagCount) {
    // 태그 개수 제한을 설정하는 메서드 (예: 최대 30개)
    if (tagCount > 3) {
      // 태그가 30개를 초과하면 30개까지만 유지
      _tag = _tag.sublist(0, 3);
    }
    notifyListeners();
  }

  List<String> extractTags(String text) {
    final RegExp regex = RegExp(r'#\w+');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }



  @override
  void dispose() {
    // 리소스 해제
    titleController.dispose();
    contentController.dispose();
    customTagController.dispose();
    super.dispose();
  }
}
