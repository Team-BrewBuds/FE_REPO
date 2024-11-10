import 'dart:developer';

import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import '../../data/profile/profile_repository.dart';
import '../../features/signup/models/signup_lists.dart';
import '../../model/profile.dart';

final class ProfileEditPresenter extends ChangeNotifier {
  // 커피 생활 선택에 필요한 리스트
  final ProfileRepository _repository;
  final SignUpLists _lists = SignUpLists();
  List<bool> _selectedItems = List.generate(6, (_) => false);
  List<String> _selectedChoices = [];

  ProfileEditPresenter({
    required ProfileRepository repository ,
}) : _repository = repository;



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


  void getProfileInfo(){
    _repository.fetchProfile();
  }

  void editProfile(){
    Map<String,dynamic> map = {};
    // Profile _pro = Profile(nickname: nickname)
     _repository.fetchUpdateProfile(map);
  }


}