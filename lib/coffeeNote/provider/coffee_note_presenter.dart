import 'dart:io';

import 'package:brew_buds/coffeeNote/controller/custom_controller.dart';
import 'package:brew_buds/coffeeNote/model/beanInfo.dart';
import 'package:brew_buds/data/repository/post_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../data/signup/auth_service.dart';
import '../../features/signup/state/signup_state.dart';
import '../../profile/model/country.dart';

final class CoffeeNotePresenter extends ChangeNotifier {
  SignUpState _state = const SignUpState();







  int? get acidity => _state.preferredBeanTaste?.acidity;

  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool _click = false;

  bool get click => _click;

  bool _toggle = false;

  bool get toggle => _toggle;

  bool _isshow = false;

  bool get isshow => _isshow;

  String _title = '';

  String get title => _title;

  // 음료 유형
  bool _hot = true;
  bool get hot => _hot;
  bool _ice = false;
  bool get ice =>_ice;
  bool _bevType = false;
  bool get bevType => _bevType;

  checkHot(){
   if(!_bevType){
     _bevType = true;
   }
   print(_bevType);
   notifyListeners();
  }

  checkIce(){
    if (_bevType) {
      _bevType = false;
    }
    print(_bevType);
    notifyListeners();
  }


  void selectA() {

  }




  // 로스팅 점수
  int roastPoint = 0;




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

  int bodyPoint = 0;
  int acidityPoint = 0;
  int bitterPoint = 0;
  int sweetPoint = 0;
  int starPoint = 0;


  List<BeanFlavor> get flavor => BeanFlavor.values;

  List<ExtractionType> get extractionInfo => ExtractionType.values;

  List<ProcessType> get processInfo => ProcessType.values;
  List<String> extractionList = [];
  List<String> processList = [];
  List<String> tasteFlaver = [];
  List<int> selectedIndexes = List.filled(4, -1);
  //원두 추출방식
  extractionFilter(ExtractionType extraction) {
    if (extractionInfo.contains(extraction)) {
      if (extractionList.contains(extraction.name)) {
        extractionList.remove(extraction.name);
      } else {
        extractionList.add(extraction.name);
      }
      print(extractionList); // 현재 상태 출력
    }
    notifyListeners();
  }

  // 원두 가공방식
  processFilter(ProcessType process) {
    if (processInfo.contains(process)) {
      if (processList.contains(process.name)) {
        processList.remove(process.name);
      } else {
        processList.add(process.name);
      }
      print(processList); // 현재 상태 출력
    }
    notifyListeners();
  }

  addExtranctionEtcValue(String etc) {
    if (click) {
      extractionList.add(etc);
    }
    notifyListeners();
  }

  addProcessEtcValue(String etc) {
    if (isshow) {
      processList.add(etc);
    } else {
      processList.remove(etc);
    }
    notifyListeners();
  }

  onChangeRoastPoing(int index) {
    roastPoint = index;
    notifyListeners();
  }

  onChangeTastPoint(int categoryIndex, int valueIndex){
    selectedIndexes[categoryIndex] = valueIndex;
    notifyListeners();
  }

  onSelectTasteFlavor(String value) {
    // tasteFlaver의 길이가 4개 미만인 경우
    if (tasteFlaver.length < 4) {
      if (tasteFlaver.contains(value)) {
        // 중복된 값이 있으면 제거
        tasteFlaver.remove(value);
      } else {
        // 중복되지 않으면 리스트에 추가
        tasteFlaver.add(value);
      }
    } else {
      if (tasteFlaver.contains(value)) {
        // 중복된 값이 있으면 제거
        tasteFlaver.remove(value);
      } else {
        // tasteFlaver가 이미 4개일 때는 추가할 수 없으므로 아무 동작도 하지 않음
        print('Cannot add more than 4 items');
      }
    }

    print(tasteFlaver);  // 현재 tasteFlaver 출력
    notifyListeners();
  }

  void clearList(List<String> items){
    items.clear();
    notifyListeners();
  }


  // 제목 설정
  void setTitle(String title) {
    _title = title;
    notifyListeners();
  }

  void initialize() {}

  onClick() {
    _click = !_click;
    notifyListeners();
  }

  isClick() {
    _isshow = !_isshow;
    notifyListeners();
  }

  isBevType() {
    _bevType = !_bevType;
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
