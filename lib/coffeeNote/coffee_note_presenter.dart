import 'package:flutter/cupertino.dart';

final class CoffeeNotePresenter extends ChangeNotifier {

  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String _title = '게시글 주제를 선택해주세요';

  String get title => _title;







  void setTitle(String title){
    _title = title;
    notifyListeners();
  }


}