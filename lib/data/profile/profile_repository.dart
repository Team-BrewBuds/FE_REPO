import 'package:brew_buds/core/authDio.dart';
import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/data/profile/profile_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../model/profile.dart';
import '../../model/user.dart';

class ProfileRepository {
  final ProfileApi _api;

  ProfileRepository._()
      : _api = ProfileApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;



  //프로필 정보 가져오기
  Future<Profile> fetchProfile() async {
    final dio = await authDio();
    final profileApi = ProfileApi(dio);
    final profile = await profileApi.fetchProfile();
    return profile;
  }

  //프로필 수정
  Future<void> editProfile(Map<String, dynamic> data) async {
    final dio = await authDio();
    final profileApi = ProfileApi(dio);
    await profileApi.patchProfile(map: data);
  }
}
