import 'dart:developer';

import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/features/login/views/login_page_first.dart';
import 'package:brew_buds/features/signup/views/signup_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../data/profile/profile_repository.dart';
import '../../features/signup/models/signup_lists.dart';
import '../../model/profile.dart';
import '../../model/recommended_user.dart';
import '../../model/user.dart';

final class ProfileEditPresenter extends ChangeNotifier {
  final ProfileRepository _repository;

  // 커피 생활 선택에 필요한 리스트
  final SignUpLists _lists = SignUpLists();
  List<bool> _selectedItems = List.generate(6, (_) => false);
  List<String> _selectedChoices = [];
  late List<String> _life = [];
  late List<String> _trueKeys = [];

  ProfileEditPresenter({
    required ProfileRepository repository,
  }) : _repository = repository;

  SignUpLists get lists => _lists;

  List<bool> get selectedItems => _selectedItems;

  List<String> get selectedChoices => _selectedChoices;

  List<String> get life => _life;

  List<String> get trueKeys => _trueKeys;

  List<String> getCoffeLifes() {
    Profile profile = _repository.fetchProfile() as Profile;
    _trueKeys = profile.coffLife.entries
        .where((entry) => entry.value) // value가 true인 항목 필터링
        .map((entry) => entry.key) // key만 추출
        .toList();

    _life = _lists.enjoyItems
        .where((item) =>
            trueKeys.contains(item["choice"])) // trueKeys에 choice가 포함된 항목 필터링
        .map((item) => item["title"]!) // title 값만 추출
        .toList();

    return _life;
  }

  final List<RecommendedUser> dummyRecommendedUsers = [
    RecommendedUser(
        user: User(
            id: 0,
            nickname: '김씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 1985789),
    RecommendedUser(
        user: User(
            id: 1,
            nickname: '이씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 3452),
    RecommendedUser(
        user: User(
            id: 2,
            nickname: '박씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 1985456789),
    RecommendedUser(
        user: User(
            id: 3,
            nickname: '홍씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 33425),
    RecommendedUser(
        user: User(
            id: 4,
            nickname: '임씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 234672),
    RecommendedUser(
        user: User(
            id: 5,
            nickname: '윤씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 62456),
    RecommendedUser(
        user: User(
            id: 6,
            nickname: '왕씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 234),
    RecommendedUser(
        user: User(
            id: 7,
            nickname: '송씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 6435735),
    RecommendedUser(
        user: User(
            id: 8,
            nickname: '류씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 563),
    RecommendedUser(
        user: User(
            id: 9,
            nickname: '강씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 2346),
    RecommendedUser(
        user: User(
            id: 10,
            nickname: '심씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 9456),
    RecommendedUser(
        user: User(
            id: 11,
            nickname: '오씨',
            profileImageUri: 'https://picsum.photos/600/400',
            isFollowed: false),
        followerCount: 23457),
  ];

  void cardChoices(int index) {
    _selectedItems[index] = !_selectedItems[index];
    if (_selectedItems[index]) {
      _selectedChoices.add(_lists.enjoyItems[index]['title']!);
    } else {
      _selectedChoices.remove(_lists.enjoyItems[index]['title']!);
    }

    print(_selectedChoices);

    notifyListeners();
  }

  void clearChoices() {
    _selectedChoices.clear();
    _selectedItems = List.generate(_selectedItems.length, (index) => false);
    notifyListeners();
  }

  Future<void> _checkPermission() async {
    await PhotoManager.requestPermissionExtend().then((ps) {
      if (ps.isAuth) {
        getAlbumbs();
      } else {
        PhotoManager.openSetting();
      }
    });
  }

  Future<void> getAlbumbs() async {
    // await PhotoManager.getAssetListPathList()
  }

  Future<void> fetchImages() async {
    final PermissionState permissionState =
        await PhotoManager.requestPermissionExtend();
    if (permissionState.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> images =
          await albums[0].getAssetListPaged(page: 0, size: 50);
    }
  }

  Future<void> getCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }
}
