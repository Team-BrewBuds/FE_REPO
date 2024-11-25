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

  ProfileRepository._() : _api = ProfileApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));


  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<Profile?> fetchProfile() async {
    final dio = await authDio();
    final profileApi = ProfileApi(dio);

    try {
      final profile = await profileApi.getProfile();
      return profile;
    } catch (e) {
      print(e);
    }
    return null;
  }

  // Future<Profile> fetchUpdateProfile(Map<String,dynamic> map) =>
  //     _token.then((token) => _api.patchProfile(token: 'Bearer $token', map: map));


}



