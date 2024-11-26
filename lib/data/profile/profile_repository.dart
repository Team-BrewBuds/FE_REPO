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
    final profile = await profileApi.getProfile();
    return profile;
  }

// Future<Profile> fetchUpdateProfile(Map<String,dynamic> map) =>
//     _token.then((token) => _api.patchProfile(token: 'Bearer $token', map: map));
}
