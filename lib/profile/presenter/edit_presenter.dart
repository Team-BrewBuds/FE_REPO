import 'dart:developer';

import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../features/signup/models/signup_lists.dart';

final class ProfileEditPresenter extends ChangeNotifier {
  // 커피 생활 선택에 필요한 리스트
  final SignUpLists _lists = SignUpLists();
  List<bool> _selectedItems = List.generate(6, (_) => false);
  List<String> _selectedChoices = [];



  SignUpLists get lists => _lists;
  List<bool> get selectedItems => _selectedItems;
  List<String> get  selectedChoices => _selectedChoices;

  void cardChoices (int  index) {
    _selectedItems[index] = !_selectedItems[index];
    if (_selectedItems[index]) {
      _selectedChoices.add(_lists.enjoyItems[index]['title']!);
    } else {
      _selectedChoices.remove(_lists.enjoyItems[index]['title']!);
    }

    print(_selectedChoices);

    notifyListeners();
  }

  void clearChoices () {
    _selectedChoices.clear();
    _selectedItems = List.generate(_selectedItems.length, (index) => false);
    notifyListeners();
  }


}