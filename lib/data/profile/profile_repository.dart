import 'package:brew_buds/data/profile/profile_api.dart';

import '../../model/profile.dart';

class ProfileRepository {
  final ProfileApi _api = ProfileApi.defaultApi();

  ProfileRepository._();

  static final ProfileRepository _instance = ProfileRepository._();

  static ProfileRepository get instance => _instance;

  factory ProfileRepository() => instance;

  Future<Profile> fetchProfile() => _api.getProfile();

  Future<Profile> fetchUpdateProfile(Map<String, dynamic> data) => _api.patchProfile(data: data);
}
