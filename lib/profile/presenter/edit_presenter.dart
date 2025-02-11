import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import '../../data/repository/profile_repository.dart';
import '../../features/signup/models/coffee_life.dart';
import '../../features/signup/models/signup_lists.dart';
import '../../model/recommended_user.dart';
import '../../model/user.dart';
import 'package:brew_buds/profile/model/profile.dart';

final class ProfileEditPresenter extends ChangeNotifier {
  // 커피 생활 선택에 필요한 리스트
  final ProfileRepository _repository;
  final SignUpLists _lists = SignUpLists();
  final List<CoffeeLife>? coffeLife = [];


  ProfileEditPresenter({
    required ProfileRepository repository ,
}) : _repository = repository;



  SignUpLists get lists => _lists;



  final List<RecommendedUser> dummyRecommendedUsers = [
    RecommendedUser(user: User(id: 0, nickname: '김씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 1985789),
    RecommendedUser(user: User(id: 1, nickname: '이씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 3452),
    RecommendedUser(user: User(id: 2, nickname: '박씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 1985456789),
    RecommendedUser(user: User(id: 3, nickname: '홍씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 33425),
    RecommendedUser(user: User(id: 4, nickname: '임씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 234672),
    RecommendedUser(user: User(id: 5, nickname: '윤씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 62456),
    RecommendedUser(user: User(id: 6, nickname: '왕씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 234),
    RecommendedUser(user: User(id: 7, nickname: '송씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 6435735),
    RecommendedUser(user: User(id: 8, nickname: '류씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 563),
    RecommendedUser(user: User(id: 9, nickname: '강씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 2346),
    RecommendedUser(user: User(id: 10, nickname: '심씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 9456),
    RecommendedUser(user: User(id: 11, nickname: '오씨', profileImageUri: 'https://picsum.photos/600/400',), followerCount: 23457),
  ];
  //
  void clearChoices () {
    coffeLife?.clear();
    notifyListeners();
  }


  void editProfile() async{
    Map<String,dynamic> map = {};
    // Profile _pro = Profile(nickname: nickname)
    await _repository.fetchUpdateProfile(map);
  }

  Future<void> _checkPermission() async{
    await PhotoManager.requestPermissionExtend().then((ps){
      if (ps.isAuth) {
        getAlbumbs();
      }else {
        PhotoManager.openSetting();
      }
    });
  }

  Future<void> getAlbumbs() async{
    // await PhotoManager.getAssetListPathList()

  }

  Future<void> fetchImages() async {
    final PermissionState permissionState = await PhotoManager.requestPermissionExtend();
    if(permissionState.isAuth) {
      List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(type: RequestType.image);
      List<AssetEntity> images = await albums[0].getAssetListPaged(page: 0, size: 50);

    }
  }

  Future<void> getCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
  }

  // 프로필 정보  가져오기
  Future<Profile> getProfile() async {
    Profile profile  = await _repository.fetchMyProfile();
    coffeLife?.add(profile.detail.coffeeLife!.first);
    print("addvalue : ${coffeLife}");
    return profile;
  }





}