import 'dart:io';

import 'package:brew_buds/coffeeNote/controller/custom_controller.dart';
import 'package:brew_buds/coffeeNote/model/beanInfo.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../profile/model/country.dart';

final class CoffeeNotePresenter extends ChangeNotifier {




  bool _isLoading = false;
  bool get isLoading => _isLoading;
  bool _click = false;
  bool get click => _click;
  String _title ='';
  String get title => _title;

  List<String> _tag = [];
  List<String> get tag => _tag;
  List<String> recordTitle = [
    '원두 추출방식 (선택)',
    '원두 로스팅 포인트 (선택)',
    '원두 가공방식 (선택)',
    '원두 생산 지역 (선택)',
    '음료 유형 (선택)',
    '로스터리 (선택)',
    '원두 품종 (선택)'
  ];
  List<BeanFlavor> get flavor => BeanFlavor.values;
  List<ExtractionType> get extractionInfo => ExtractionType.values;



  // 제목 설정
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void initialize() {
  }


  List<String> extractTags(String text) {
    final RegExp regex = RegExp(r'#\w+');
    return regex.allMatches(text).map((match) => match.group(0)!).toList();
  }

  String? validateMultiLineText(String value) {
    // Use RegExp to check for line breaks (\n or \r\n)
    RegExp regExp = RegExp(r'[\r\n]+');

    // Check if the value contains at least 2 lines
    List<String> lines = value.split(regExp);

    if (lines.length >= 2) {
      return null; // Validation passed (contains 2 or more lines)
    } else {
      return '텍스트는 최소 2줄 이상이어야 합니다'; // Return error message if not
    }
  }

  onClick(){
    _click =! _click;

    notifyListeners();
  }

  File? _image; // 선택된 이미지를 저장할 변수

  // 이미지 선택 함수
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();

    // 갤러리에서 이미지 선택
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path); // 선택된 이미지 경로를 File로 저장
      });
    }
  }

  @override
  void dispose() {

    super.dispose();
  }

  void setState(Null Function() param0) {}

  void init() {}
}
