import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AlarmPresenter extends ChangeNotifier {
  //device alarm false
  List<String> _title = ['기기 알림 설정', '혜택 정보 수신', '마케팅'];
  List<String> _content = [
    '내가 작성한 커피 노트에 대한 반응과 나를 팔로우\n하는 버디 등 꼭 필요한 것만 알려드려요.',
    ' 개인 맞춤 혜택과 이벤트 소식을 안내'
  ];
  List<bool> _list = [false, false];

  List<String> get title => _title;

  List<String> get content => _content;

  List<bool> get list => _list;

  // device alarm true
  List<String> _title2 = ['모두 일시 중단', '새로운 팔로워', '반응', '혜택 정보 수신'];
  List<String> _content2 = [
    '알림 수신 일시 중단',
    '나를 팔로우하는 버디 안내',
    '좋아요,댓글',
    '개인 맞춤 혜택과 이벤트 소식을 안내'
  ];
  List<bool> _list2 = [false, false, false, false];

  List<String> get title2 => _title2;

  List<String> get content2 => _content2;

  List<bool> get list2 => _list2;



   Future<bool> NotificationPermissionCheck() async {

    try {
      final status = await Permission.notification.status;
      //권한이 있을때
      switch(status){
        case PermissionStatus.granted:
          return true;
      //권한이 없을때 (거부했지만 다시묻지않기는 클릭하지 않은 상태)
        case PermissionStatus.denied:
          return false;
      //권한 아예 다시 묻지 않기
        case PermissionStatus.permanentlyDenied:
          Permission.notification.request();
          return false;

        default:
          print('알수 없는 상태');
      }


    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<void> loadSetting(Future<bool> value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(value==false){
      for (int i = 0; i < _list.length; i++) {
        _list[i] = prefs.getBool('notification_setting_$i') ?? false;
      }
    }else{
      for (int i = 0; i < _list2.length; i++) {
        _list2[i] = prefs.getBool('notification_setting_$i') ?? false;
      }
    }

    notifyListeners();
  }

  Future<void> saveSetting(int index, bool value, List<bool> list) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_setting_$index', value);

    list[index] = value;
    notifyListeners();
  }

}
