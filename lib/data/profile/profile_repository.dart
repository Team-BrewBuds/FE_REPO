import 'package:brew_buds/core/auth_service.dart';
import 'package:brew_buds/data/profile/profile_api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../model/profile.dart';

class ProfileRepository {
  final ProfileApi _api;

  ProfileRepository._() : _api = ProfileApi(Dio(BaseOptions(baseUrl: dotenv.get('API_ADDRESS'))));

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<String?> _token = AuthService().getToken();

  Future<Profile> fetchProfile() => _token.then((token) => _api.getProfile(token: 'Bearer $token'));

  Future<Profile> fetchUpdateProfile(Map<String, dynamic> map) =>
      _token.then((token) => _api.patchProfile(token: 'Bearer $token', map: map));
}
